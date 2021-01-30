//
//  PromoCodeModule.swift
//  PromoCode
//
//  Created by Joseph Lord on 10/01/2021.
//

import Fluent
import FeatherCore

final class PromoCodeModule: ViperModule {

    static var name: String = "promo"

    var router: ViperRouter? = PromoCodeRouter()
    
    static var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        app.databases.middleware.use(MetadataModelMiddleware<PromoOfferModel>())
//        app.databases.middleware.use(MetadataModelMiddleware<PromoCodeModel>())
        
        ///install
        app.hooks.register("user-permission-install", use: userPermissionInstallHook)
        
        /// routes
        app.hooks.register("admin", use: (router as! PromoCodeRouter).adminRoutesHook)
        app.hooks.register("public-api", use: (router as! PromoCodeRouter).publicApiRoutesHook)
        
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
    }
    
    var migrations: [Migration] {
        [
            PromoCodeMigration_v1_0_0(),
        ]
    }
    
    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "Promo Codes",
            "icon": "book",
            "permission": "promocode.module.access",
            "items": LeafData.array([
                [
                    "url": "/admin/promo/offers/",
                    "label": "Offers",
                    "permission": "promocode.offers.list",
                ],
            ])
        ]
    }
    
    func userPermissionInstallHook(args: HookArguments) -> [[String: Any]] {
        PromoCodeModule.permissions +
            PromoCodeModel.permissions +
            PromoOfferModel.permissions
    }
}
