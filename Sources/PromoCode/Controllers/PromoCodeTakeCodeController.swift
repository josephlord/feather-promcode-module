//
//  File.swift
//  
//
//  Created by Joseph on 24/01/2021.
//

import Vapor
import Fluent

final class PromoCodeTakeCodeController {

    func setupGetRoute(on builder: RoutesBuilder) {
        let fullBuilder = builder.grouped("code").grouped(":offerName")
        
        fullBuilder.get("take", use: get)
    }
    
    func get(to request: Request) -> EventLoopFuture<PromoCodeOffer> {
        let name = request.parameters.get("offerName") ?? ""
        return request.db.transaction { db in
            PromoCodeModel.query(on: db)
                .join(parent: \.$offer)
                .filter(PromoOfferModel.self, \.$name == name)
                .random()
                .unwrap(or: Vapor.Abort(.notFound))
                .map {
                    let promoCode = $0
                    let offer = try! $0.joined(PromoOfferModel.self)
                    return PromoCodeOffer(
                        code: promoCode.code,
                        offerName: offer.name,
                        offerDescription: offer.description,
                                offerExpiry: offer.expiry)
                }
                .flatMap { pCO in
                    PromoCodeModel.query(on: db)
                        .filter(\.$code == pCO.code)
                        .delete(force: true).map { pCO }
                }
        }
    }
}
