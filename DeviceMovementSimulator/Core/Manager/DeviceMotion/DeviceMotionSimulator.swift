//
//  DeviceMotionSimulator.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

extension DeviceMovementSimulator {
    
    private static let deviceMotionObservers = MotionManagerObservers()
    private static var deviceMotion: CMDeviceMotion?
}

extension DeviceMovementSimulator {

    internal func startDeviceMotionSimulation() throws {
        
        CMMotionManager.swizzleDelegate = self
        try CMMotionManager.swizzleMethods()
    }
    
    internal func stopDeviceMotionSimulation() throws {
        
        queue.sync {
            DeviceMovementSimulator.deviceMotionObservers.reset()
            DeviceMovementSimulator.deviceMotion = nil
        }
        
        CMMotionManager.swizzleDelegate = nil
        try CMMotionManager.unswizzleMethods()
    }
    
    internal func broadcast(_ deviceMotion: CMDeviceMotion) {
        
        queue.async {
            DeviceMovementSimulator.deviceMotion = deviceMotion
            self.deviceMotionObservers.notifyDeviceMotion(deviceMotion)
        }
    }
}

extension DeviceMovementSimulator: SwizzledMotionManagerProtocol {
    internal func swizzledMotionManagerDidStartDeviceMotionUpdatesWithHandler(_ handler: (CMDeviceMotionHandler?)) {
        
        deviceMotionObservers.addHandler(handler)
    }
    
    internal func swizzledMotionManagerDidStopDeviceMotionUpdates() {
        
        // No action - we only hijack the event
    }
    
    internal func swizzledMotionManagerDidRequestDeviceMotionData() -> CMDeviceMotion? {
        
        var value: CMDeviceMotion?
        queue.sync {
            value = DeviceMovementSimulator.deviceMotion
        }
        
        return value
    }
}

extension DeviceMovementSimulator {
    
    fileprivate var deviceMotionObservers: MotionManagerObservers {
        
        return DeviceMovementSimulator.deviceMotionObservers
    }
    
    fileprivate var queue: DispatchQueue {
        
        return DeviceMovementSimulator.queue
    }
}


