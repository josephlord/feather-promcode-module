//
//  PromoCodeModel.swift
//  PromoCode
//
//  Created by Joseph Lord on 10/01/2021.
//

import Vapor
import Fluent
import ViperKit
import FeatherCore

final class PromoCodeModel: ViperModel {
    typealias Module = PromoCodeModule
    
    static let name = "codes"

    struct FieldKeys {
        static var code: FieldKey { "code" }
        static var offer: FieldKey { "offer_id" }
    }
    
    @Parent(key: FieldKeys.offer) var offer: PromoOfferModel

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.code) var code: String

    init() { }

    init(id: PromoCodeModel.IDValue? = nil,
         code: String,
         offerId: UUID)
    {
        self.id = id
        self.code = code
        self.$offer.id = offerId
    }
}

