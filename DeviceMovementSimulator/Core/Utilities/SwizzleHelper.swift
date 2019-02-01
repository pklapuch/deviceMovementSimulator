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
    
    // Mark - Instance methods
    
    internal static func swizzleInstance(_ instance: AnyObject, method: ExchangableMethodImplementationProtocol) {
        
        let instanceClass: AnyClass! = object_getClass(instance)
        exchangeInstanceSelectorInClass(aClass: instanceClass, source: method.original, dest: method.custom)
    }
    
    internal static func unswizzleInstance(_ instance: AnyObject, method: ExchangableMethodImplementationProtocol) {
        
        let instanceClass: AnyClass! = object_getClass(instance)
        exchangeInstanceSelectorInClass(aClass: instanceClass, source: method.custom, dest: method.original)
    }
    
    fileprivate static func exchangeInstanceSelectorInClass(aClass: AnyClass, source: Selector, dest: Selector) {
        
        if let source = class_getInstanceMethod(aClass, source) {
            if let dest = class_getInstanceMethod(aClass, dest) {
                method_exchangeImplementations(source, dest)
            }
        }
    }
}

extension Swizzle {
    
    // Mark - Class methods
    
    internal static func swizzleClass(_ aClass: AnyClass, method: ExchangableMethodImplementationProtocol) {
        
        exchangeClassSelectorInClass(aClass: aClass, source: method.original, dest: method.custom)
    }
    
    internal static func unswizzleClass(_ aClass: AnyClass, method: ExchangableMethodImplementationProtocol) {
        
        exchangeClassSelectorInClass(aClass: aClass, source: method.custom, dest: method.original)
    }
    
    fileprivate static func exchangeClassSelectorInClass(aClass: AnyClass, source: Selector, dest: Selector) {
        
        if let source = class_getClassMethod(aClass, source) {
            if let dest = class_getClassMethod(aClass, dest) {
                method_exchangeImplementations(source, dest)
            }
        }
    }
}
