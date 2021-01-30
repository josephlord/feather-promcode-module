//
//  PromoCodeMigration_v1_0_0.swift
//  PromoCode
//
//  Created by Joseph Lord on 10/01/2021.
//

import Vapor
import Fluent

struct PromoCodeMigration_v1_0_0: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema("promo_offers")
                .id()
                .field("name", .string, .required)
                .field("description", .string, .required)
                .field("expiry", .datetime, .required)
                .unique(on: "name")
                .create(),
            db.schema("promo_codes")
                .id()
                .field("code", .string)
                .field("offer_id", .uuid, .references("promo_offers", "id"))
                .foreignKey("offer_id", references: "promo_offers", "id", onDelete: .cascade, onUpdate: .cascade, name: "promo_offer_fk")
                .unique(on: "code")
                .create(),
        ])
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema("promo_codes").delete(),
            db.schema("promo_offers").delete(),
        ])
    }
}
