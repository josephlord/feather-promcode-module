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

final class PromoOfferModel: ViperModel {
    typealias Module = PromoCodeModule

    static let name = "offers"

    struct FieldKeys {
        static var name: FieldKey { "name" }
        static var description: FieldKey { "description" }
        static var expiry: FieldKey { "expiry" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.description) var description: String
    @Field(key: FieldKeys.expiry) var expiry: Date
    @Children(for: \.$offer)
    var codes: [PromoCodeModel]
    
    init() { }

    init(id: UUID? = nil,
         name: String,
         description: String,
         expiry: Date)
    {
        self.id = id
        self.name = name
        self.description = description
        self.expiry = expiry
    }
}

extension PromoOfferModel {
    
    var countCount: Int? {
        self.$codes.value?.count
    }
}

extension PromoOfferModel : MetadataRepresentable {
    var metadata: Metadata {
        .init(slug: (Self.name + "/" + name).slugify(), title: name, excerpt: description)
    }
}

extension PromoOfferModel: LeafDataRepresentable {
    var leafData: LeafData {
        .dictionary([
            "id": id,
            "name": name,
            "description": description,
            "expiry": expiry,
            "availableCodes": countCount
        ])
    }
}

extension GetOfferInfoDTO: LeafDataRepresentable {
    var leafData: LeafData {
        .dictionary([
            "id": id,
            "name": name,
            "description": description,
            "expiry": expiry,
            "availableCodes": availableCodes
        ])
    }
}

struct GetOfferInfoDTO: Content  {
    var id: UUID
    var name: String
    var description: String
    var expiry: Date
    var availableCodes: Int?
}
