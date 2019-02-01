//
//  Configuration.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreLocation

extension Configuration {
    
    internal static var initial: Configuration {
        
        return Configuration()
    }
    
    internal func createLocationManager() -> CLLocationManager {
        
        let manager = CLLocationManager()
        
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.allowsBackgroundLocationUpdates = simulateBackgroundUpdates
        manager.pausesLocationUpdatesAutomatically = false
        manager.showsBackgroundLocationIndicator = false
        
        return manager
    }
}
