//
//  File.swift
//  
//
//  Created by Joseph on 24/01/2021.
//

import Fluent

extension QueryBuilder {
    func random() -> EventLoopFuture<Model?> {
        return self
            .sort(.custom("random()"))
            .first()
    }

}
