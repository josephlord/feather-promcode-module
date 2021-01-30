//
//  File.swift
//  
//
//  Created by Joseph on 10/01/2021.
//

import FeatherCore

@_cdecl("createPromoCodeModule")
public func createPromoCodeModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(PromoCodeBuilder()).toOpaque()
}

public final class PromoCodeBuilder: ViperBuilder {

    public override func build() -> ViperModule {
        PromoCodeModule()
    }
}
