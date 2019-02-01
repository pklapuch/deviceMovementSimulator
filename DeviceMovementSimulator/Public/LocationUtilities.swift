//
//  LocationUtilities.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 01/02/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import CoreLocation

@objc(DMSLocationUtilities)
public class LocationUtilities: NSObject {
    
    public static var zero: CLLocation {
        return CLLocation.zero
    }
}

internal extension CLLocation {
    
    internal static var zero: CLLocation {
        return CLLocation(latitude: 0.0, longitude: 0.0)
    }
    
    
}
