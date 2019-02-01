//
//  SwizzleHelper.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreLocation

internal struct Swizzle {
    
    internal static func swizzleInstance(_ instance: AnyObject, method: ExchangableMethodImplementationProtocol) {
        
        let instanceClass: AnyClass! = object_getClass(instance)
        exchangeSelectorInClass(instanceClass: instanceClass, source: method.original, dest: method.custom)
    }
    
    internal static func unswizzleInstance(_ instance: AnyObject, method: ExchangableMethodImplementationProtocol) {
        
        let instanceClass: AnyClass! = object_getClass(instance)
        exchangeSelectorInClass(instanceClass: instanceClass, source: method.custom, dest: method.original)
    }
    
    fileprivate static func exchangeSelectorInClass(instanceClass: AnyClass, source: Selector, dest: Selector) {
        
        if let source = class_getInstanceMethod(instanceClass, source) {
            if let dest = class_getInstanceMethod(instanceClass, dest) {
                method_exchangeImplementations(source, dest)
            }
        }
    }
}
