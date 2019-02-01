//
//  AuthorizationStatusExtensions.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import CoreLocation

extension CLAuthorizationStatus {
    internal var authorizationType: RealLocationManager.AuthorizationType {
        switch self {
        case .notDetermined:
            return .unknown
        case .authorizedWhenInUse:
            return .whenInUse
        case .authorizedAlways:
            return .always
        default:
            return .denied
        }
    }
}
