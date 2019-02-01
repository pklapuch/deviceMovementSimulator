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
        
        guard !hasSwizzledMethods else { throw Error.invalidState }
        hasSwizzledMethods = true
        methods.forEach { Swizzle.swizzleInstance(CLLocationManager(), method: $0) }
    }
    
    internal static func unswizzleMethods() throws {
        
        guard hasSwizzledMethods else { throw Error.invalidState }
        hasSwizzledMethods = false
        methods.forEach { Swizzle.unswizzleInstance(CLLocationManager(), method: $0) }
    }
    
    fileprivate static let methods: [ExchangableMethodImplementationProtocol] = [
        
        Methods.setDelegate,
        Methods.requestAuthorizationInUse,
        Methods.requestAuthorizationAlways,
        Methods.startLocationUpdates,
        Methods.stopLocationUpdates
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
}
