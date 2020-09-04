//
//  Configuration.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation

@objc(DMSConfiguration)
public class Configuration: NSObject {
    
    /** If false, simulation will not subscribe to system location updates -> simulation will only work in foreground
        If true, simulation will register background updates with system -> simulation can run in background
        Background operation is only possible provided user has accepted privacy settings 
     */
    let simulateBackgroundUpdates: Bool
    
    @objc(init:)
    public init(simulateBackgroundUpdates: Bool) {
        
        self.simulateBackgroundUpdates = simulateBackgroundUpdates
    }
}
