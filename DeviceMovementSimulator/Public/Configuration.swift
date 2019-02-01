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
    
    /** If false, simulation will not subscribe to system location updates -> app cann be suspended while in bg
        If true, simulation will register background updates with system which will trigger privacy alerts and should keep app running in bg
        It is user's responsibility to accept privacy settings popup when requested by system - otherwise app can be suspended anyways.
     */
    let simulateBackgroundUpdates: Bool
    let preferredAuthorization: RequestAuthorization
    
    public init(simulateBackgroundUpdates: Bool? = nil, preferredAuthorization: RequestAuthorization? = nil) {
        
        self.simulateBackgroundUpdates = simulateBackgroundUpdates ?? false
        self.preferredAuthorization = preferredAuthorization ?? .whenInUse
    }
}
