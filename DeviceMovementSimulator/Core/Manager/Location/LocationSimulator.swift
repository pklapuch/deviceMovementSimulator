//
//  LocationSimulator.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

extension DeviceMovementSimulator {
    
    private static let locationObservers = LocationManagerObservers()
}

extension DeviceMovementSimulator {
    
    internal func startLocationSimulation() throws {
        
        CLLocationManager.swizzleDelegate = self
        try CLLocationManager.swizzleMethods()
    }
    
    internal func stopLocationSimulation() throws {
        
        queue.sync {
            DeviceMovementSimulator.locationObservers.reset()
        }
        
        CLLocationManager.swizzleDelegate = nil
        try CLLocationManager.unswizzleMethods()
    }
    
    internal func broadcast(_ location: CLLocation) {
        
        locationObservers.notifyLocation(location)
    }
}

extension DeviceMovementSimulator: SwizzledLocationManagerProtocol {
    
    internal func swizzledLocationManager(_ manager: CLLocationManager, didSetDelegate delegate: CLLocationManagerDelegate?) {
        
        if let delegate = delegate {
            locationObservers.addObserverWithDelegate(delegate, manager: manager)
        } else {
            locationObservers.removeObserverWithManager(manager)
        }
    }
    
    internal func swizzledLocationManager(_ manager: CLLocationManager, didRequestAuthorization authorization: RequestAuthorization) {
        
        locationObservers.notifyAuthorizationStatus(authorization.status)
    }
    
    internal func swizzledLocationManagerStartTracking(_ manager: CLLocationManager) {
        
        // No action - we only hijack the event
    }
    
    internal func swizzledLocationManagerStopTracking(_ manager: CLLocationManager) {
        
        // No action - we only hijack the event
    }
}

extension DeviceMovementSimulator {
    
    fileprivate var locationObservers: LocationManagerObservers {
        
        return DeviceMovementSimulator.locationObservers
    }
    
    fileprivate var queue: DispatchQueue {
        
        return DeviceMovementSimulator.queue
    }
}
