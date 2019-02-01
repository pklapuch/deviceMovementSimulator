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
    internal static var defaultLocationManager: DefaultLocationManager?
    fileprivate static var prepareBackgroundUpdatesBlock: PrepareBackgroundUpdates?
    
    internal func processConfiguration(_ configuration: Configuration, completion: PrepareBackgroundUpdates) {
        DeviceMovementSimulator.defaultLocationManager = DefaultLocationManager(configuration: configuration, delegate: self)
        DeviceMovementSimulator.defaultLocationManager?.start()
    }
    
    internal func start() throws {
        
        do {
            try startLocationSimulation()
            try startDeviceMotionSimulation()
        }
    }
    
    internal func stop() throws {
        
        do {
            try stopLocationSimulation()
            try stopDeviceMotionSimulation()
        }
    }
}

extension DeviceMovementSimulator: DefaultLocationManagerProtocol {
    func defaultLocationManagerDidStartTrackingLocation(_ manager: DefaultLocationManager) {
        DeviceMovementSimulator.queue.async {
            if let block = DeviceMovementSimulator.prepareBackgroundUpdatesBlock {
                block()
            }
            DeviceMovementSimulator.prepareBackgroundUpdatesBlock = nil
        }
    }
}
