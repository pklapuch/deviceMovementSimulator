//
//  RequestAuthorization.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreLocation

@objc(DMSRequestAuthorization)
public enum RequestAuthorization: Int {
    
    case whenInUse
    case always
}
