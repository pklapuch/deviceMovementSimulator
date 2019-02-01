//
//  DeviceMovementSimulator.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

public class DeviceMovementSimulator: NSObject {
    
    @objc(sharedManager)
    public static let shared = DeviceMovementSimulator()
    
    /// Applies method swizzling
    /// Throws if simulator is already enabled
    ///
    @objc(enableWithConfiguration:error:)
    public func enableWith(_ configuration: Configuration) throws {
        try startWithConfiguration(configuration)
    }
    
    /// Undos method swizzling
    /// Throws if simulator is already disabled
    ///
    @objc(disableWithError:)
    public func disable() throws {
        try stop()
    }
    
    /// Notifies all location manager delegates with new data
    /// If simulator is not enabled, this method has no effect
    ///
    @objc(simualteLocation:)
    public func simulate(_ location: CLLocation) {
        broadcast(location)
    }
    
    /// Notifies all device motion delegates with new data
    /// If simulator is not enabled, this method has no effect
    ///
    @objc(simualteDeviceMotion:)
    public func simulate(_ deviceMotion: CMDeviceMotion) {
        broadcast(deviceMotion)
    }
}
