//
//  PromoCodeFrontendController.swift
//  PromoCode
//
//  Created by Joseph Lord on 10/01/2021.
//

import FeatherCore
import Fluent
import Vapor
import FluentSQL
import SQLKit
import ViewKit

final class PromoOfferAdminController : ViperAdminViewController {
    typealias Module = PromoCodeModule
    typealias Model = PromoOfferModel
    typealias CreateForm = PromoOfferEditForm
    typealias UpdateForm = PromoOfferEditForm
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.name,
        Model.FieldKeys.expiry,
        "available_codes"
    ]
    
    func listQuery(search: String, queryBuilder: QueryBuilder<PromoOfferModel>, req: Request) {
        queryBuilder.filter(\.$name ~~ search)
    }
    
    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<PromoOfferModel>) -> QueryBuilder<PromoOfferModel> {
        return Model.query(on: req.db)
            .joinMetadata()
            .with(\.$codes)
    }

    func listQuery(order: FieldKey, sort: ListSort, queryBuilder: QueryBuilder<PromoOfferModel>, req: Request) -> QueryBuilder<PromoOfferModel> {
        return queryBuilder.sort(order, sort.direction)
    }
    
    func beforeListPageRender(page: ListPage<PromoOfferModel>) -> LeafData {
        assertionFailure("Not used as listView overriden to use beforeListPageRenderDTO")
        return .dictionary([
            "items": .array(page.items.map(\.leafDataWithJoinedMetadata)),
            "info": page.info.leafData
        ])
    }

    
    func beforeListPageRenderDTO(page: ListPage<GetOfferInfoDTO>) -> LeafData {
        return .dictionary([
            "items": .array(page.items.map(\.leafData)),
            "info": page.info.leafData
        ])
    }
    
    
    func listView(req: Request) throws -> EventLoopFuture<View> {
        guard let sqlDB = req.db as? SQLDatabase else { return req.eventLoop.future(error: Abort(.forbidden)) }
        /// first we need a QueryBuilder instance, we apply the beforeList method on the default query
        

        var qb = beforeListQuery(req: req, queryBuilder: Model.query(on: req.db))

        /// next we get the sort from the query, if there was no sort key we use the default sort
        var sort = listDefaultSort
        if let sortQuery: String = req.query[listSortKey], let sortValue = ListSort(rawValue: sortQuery) {
            sort = sortValue
        }
        var orderBy: String = listAllowedOrders[0].description
        /// if custom ordering is allowed
        if !listAllowedOrders.isEmpty {
            /// we check for a new order using the query, otherwise we use the first element of the allowed orders
            let orderValue: String = req.query[listOrderKey] ?? listAllowedOrders[0].description
            let order = FieldKey(stringLiteral: orderValue)
            /// only allow ordering if the order value is in the allowed orders array
            if listAllowedOrders.contains(order) {
                qb = listQuery(order: order, sort: sort, queryBuilder: qb, req: req)
                orderBy = orderValue
            }
        }

        /// check if there is a non-empty search term and apply the search term using the custom search method
        if let searchTerm: String = req.query[listSearchKey], !searchTerm.isEmpty {
            qb = qb.group(.or) { listQuery(search: searchTerm, queryBuilder: $0, req: req) }
        }

        /// apply the limit and page properties
        let limit: Int = req.query[listLimitKey] ?? listDefaultLimit
        let page: Int = max((req.query[listPageKey] ?? 1), 1)

        /// calculate the start and end position
        let start: Int = (page - 1) * limit
//        let end: Int = page * limit

        /// count the total number of elements for the page info
        let count = qb.count()
        
        /// Setup the full raw query so we can get the counts without fetching tens of thousands of 
        
        let queryString = """
        SELECT *
            FROM promo_offers
        LEFT OUTER JOIN
            (SELECT offer_id AS id, count(*) as availableCodes
                FROM promo_codes
                GROUP BY offer_id)
            USING (id)
        ORDER BY \(orderBy) \(sort.rawSql)
        LIMIT \(limit)
        OFFSET \(start)
        """
        let query = sqlDB.raw(SQLQueryString(queryString))
        
        let advancedItems = query
            .all(decoding: GetOfferInfoDTO.self)

        ///query both the total count and the models for the requested page
        return advancedItems.and(count).map { (models, total)  -> ListPage<GetOfferInfoDTO> in
            let totalPages = Int(ceil(Float(total) / Float(limit)))
            return ListPage(models, info: .init(current: page, limit: limit, total: totalPages))
        }
        /// map the page elements to Leaf values & render the list view
        .map { self.beforeListPageRenderDTO(page: $0) }
        .flatMap { self.render(req: req, template: self.listView, context: ["list": $0]) }
    }

    // MARK: - edit
    
    internal func findBy(_ id: UUID, on: Database) -> EventLoopFuture<PromoOfferModel> {
        PromoOfferModel.query(on: on)
            .filter(\.$id == id)
            .with(\PromoOfferModel.$codes)
            .first()
            .unwrap(or: Vapor.Abort(.notFound))
    }

    func afterCreate(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }

    func afterUpdate(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        return model.$codes.query(on: req.db).delete(force: true).map { model }
    }
    
    func exampleView(req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            let foo: String
        }
        let context = Context(foo: "This is just an example")
        return req.view.render("PromoCode/Frontend/Example", context)
    }

}

extension ListSort {
    var rawSql: String {
        switch self {
        case .asc: return "ASC"
        case .desc: return "DESC"
        }
    }
}
