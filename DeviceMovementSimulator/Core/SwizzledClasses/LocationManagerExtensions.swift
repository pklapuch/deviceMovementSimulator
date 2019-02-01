//
//  LocationManagerExtensions.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreLocation

internal protocol SwizzledLocationManagerProtocol: class {
    
    func swizzledLocationManager(_ manager: CLLocationManager, didSetDelegate delegate: CLLocationManagerDelegate?)
    func swizzledLocationManager(_ manager: CLLocationManager, didRequestAuthorization authorization: RequestAuthorization)
    func swizzledLocationManagerStartTracking(_ manager: CLLocationManager)
    func swizzledLocationManagerStopTracking(_ manager: CLLocationManager)
}

extension CLLocationManager {
    
    internal static weak var swizzleDelegate: SwizzledLocationManagerProtocol?
    internal(set) static var hasSwizzledMethods = false
    
    internal static func swizzleMethods() throws {
        
        guard !hasSwizzledMethods else { throw Error.simulatorAlreadyStarted }
        hasSwizzledMethods = true
        methods.forEach { Swizzle.swizzleInstance(CLLocationManager(), method: $0) }
        classMethods.forEach { Swizzle.swizzleClass(CLLocationManager.self, method: $0) }
    }
    
    internal static func unswizzleMethods() throws {
        
        guard hasSwizzledMethods else { throw Error.simulatorAlreadyStopped }
        hasSwizzledMethods = false
        methods.forEach { Swizzle.unswizzleInstance(CLLocationManager(), method: $0) }
        classMethods.forEach { Swizzle.unswizzleClass(CLLocationManager.self, method: $0) }
    }
    
    fileprivate static let methods: [ExchangableMethodImplementationProtocol] = [
        
        Methods.setDelegate,
        Methods.requestAuthorizationInUse,
        Methods.requestAuthorizationAlways,
        Methods.startLocationUpdates,
        Methods.stopLocationUpdates
    ]
    
    fileprivate static let classMethods: [ExchangableMethodImplementationProtocol] = [
        
        ClassMethods.locationServicesEnabled
    ]
}

extension CLLocationManager {
    
    @objc internal func customSetDelegate(_ delegate: CLLocationManagerDelegate?) {
        
        CLLocationManager.swizzleDelegate?.swizzledLocationManager(self, didSetDelegate: delegate)
    }
    
    @objc internal func customRequestWhenInUseAuthorization() {
        
        CLLocationManager.swizzleDelegate?.swizzledLocationManager(self, didRequestAuthorization: .whenInUse)
    }
    
    @objc internal func customRequestAlwaysAuthorization() {
        
        CLLocationManager.swizzleDelegate?.swizzledLocationManager(self, didRequestAuthorization: .always)
    }
    
    @objc internal func customStartUpdatingLocation() {
        
        CLLocationManager.swizzleDelegate?.swizzledLocationManagerStartTracking(self)
    }
    
    @objc internal func customStopUpdatingLocation() {
        
        CLLocationManager.swizzleDelegate?.swizzledLocationManagerStopTracking(self)
    }
    
    @objc internal static func customLocationServicesEnabled() -> Bool {
        
        return true
    }
}

extension CLLocationManager {
    
    internal func realSetDelegate(_ delegate: CLLocationManagerDelegate) {
        
        if (CLLocationManager.hasSwizzledMethods) {
            customSetDelegate(delegate)
        } else {
            self.delegate = delegate
        }
    }
    
    internal func realRequestWhenInUseAuthorization() {
     
        if (CLLocationManager.hasSwizzledMethods) {
            customRequestWhenInUseAuthorization()
        } else {
            requestWhenInUseAuthorization()
        }
    }
    
    internal func realRequestAlwaysAuthorization() {
        
        if (CLLocationManager.hasSwizzledMethods) {
            customRequestAlwaysAuthorization()
        } else {
            requestAlwaysAuthorization()
        }
    }
    
    internal func realStartUpdatingLocation() {
        
        if (CLLocationManager.hasSwizzledMethods) {
            customStartUpdatingLocation()
        } else {
            startUpdatingLocation()
        }
    }
    
    internal func realStopUpdatingLocation() {
        
        if (CLLocationManager.hasSwizzledMethods) {
            customStopUpdatingLocation()
        } else {
            stopUpdatingLocation()
        }
    }
    
    internal static func realLocationServicesEnabled() -> Bool {
        
        if (CLLocationManager.hasSwizzledMethods) {
            return CLLocationManager.customLocationServicesEnabled()
        } else {
            return CLLocationManager.locationServicesEnabled()
        }
    }
}
