//
//  Simulator.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

extension DeviceMovementSimulator {
    
    internal static let queue = DispatchQueue(label: "\(productIdentifier).\(DeviceMovementSimulator.nameOfClass)")
    internal static var realLocationManager: RealLocationManager?
    
    internal func startWithConfiguration(_ configuration: Configuration) throws {
        
        do {
            try startLocationSimulation()
            try startDeviceMotionSimulation()
        }
        
        if (configuration.simulateBackgroundUpdates) {
            DeviceMovementSimulator.realLocationManager = RealLocationManager(configuration: configuration)
            DeviceMovementSimulator.realLocationManager?.start()
        }
    }
    
    internal func stop() throws {
        
        DeviceMovementSimulator.realLocationManager?.stop()
        
        do {
            try stopLocationSimulation()
            try stopDeviceMotionSimulation()
        }
    }
}
