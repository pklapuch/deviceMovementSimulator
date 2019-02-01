//
//  RequestAuthorizationExtensions.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreLocation

extension RequestAuthorization {
    
    internal var status: CLAuthorizationStatus {
        switch self {
        case .whenInUse:
            return .authorizedWhenInUse
        case .always:
            return .authorizedAlways
        }
    }
}
