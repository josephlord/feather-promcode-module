//
//  PromoCodeRouter.swift
//  PromoCode
//
//  Created by Joseph Lord on 10/01/2021.
//

import FeatherCore

final class PromoCodeRouter: ViperRouter {

//    let controller = PromoCodeFrontendController()

    let offerAdmin = PromoOfferAdminController()
    let offerApi = PromoCodeTakeCodeController()
    
    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(PromoCodeModule.pathComponent)

        offerAdmin.setupRoutes(on: modulePath, as: PromoOfferModel.pathComponent)
        
    }
    
    func publicApiRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder
        
        let modulePath = routes.grouped(PromoCodeModule.pathComponent)
        
        offerApi.setupGetRoute(on: modulePath)
        
//
//        modulePath.add(
//            Route(
//                method: .GET,
//                path: ["code/:offerName/take/"],
//                responder: offerApi,
//                requestType: ClientRequest.Type.self,
//                responseType: PromoCodeOffer.self))
        //offerApi.setupGetRoute(on: offerPath)
    }
}
