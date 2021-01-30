//
//  File.swift
//  
//
//  Created by Joseph on 13/01/2021.
//

import Vapor
import ViewKit
import FluentSQL

struct PromoCode : Codable {
    var promoCode: String
    var offer: PromoOffer
    
    internal init(promoCode: String, offer: PromoOffer) {
        self.promoCode = promoCode
        self.offer = offer
    }
    
    init(model: PromoCodeModel) {
        self.promoCode = model.code
        self.offer = PromoOffer(model: model.offer)
    }
}

struct PromoOffer : Codable {
    

    var id: UUID?
    var name: String
    var description: String
    var expiry: Date
    var availableCodes: Int?
    
    internal init(id: UUID? = nil,
                  name: String,
                  description: String,
                  expiry: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.expiry = expiry
    }
    
    init(model: PromoOfferModel) {
        id = model.id
        name = model.name
        description = model.description
        expiry = model.expiry
    }
}

struct PromoCodeOffer : Content {
    
    var code: String
    var offerName: String
    var offerDescription: String
    var offerExpiry: Date
    
    internal init(code: String, offerName: String, offerDescription: String, offerExpiry: Date) {
        self.code = code
        self.offerName = offerName
        self.offerDescription = offerDescription
        self.offerExpiry = offerExpiry
    }
}

extension PromoCodeOffer  {

}
