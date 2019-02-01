//
//  LocationManagerMethods.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationManager {
    
    internal struct Methods {
        
        static let setDelegate = SetDelegateMethod()
        static let requestAuthorizationInUse = RequestAuthorizationInUseMethod()
        static let requestAuthorizationAlways = RequestAuthorizationAlwaysMethod()
        static let startLocationUpdates = StartLocationUpdatesMethod()
        static let stopLocationUpdates = StopLocationUpdatesMethod()
    }
    
    internal struct ClassMethods {
        
        static let locationServicesEnabled = LocationServicesEnabled()
    }
    
    internal struct SetDelegateMethod: ExchangableMethodImplementationProtocol {
        
        var original: Selector {
            return #selector(setter: delegate)
        }
        
        var custom: Selector {
            return #selector(customSetDelegate(_:))
        }
    }

    internal struct RequestAuthorizationInUseMethod: ExchangableMethodImplementationProtocol {
        
        var original: Selector {
            return #selector(requestWhenInUseAuthorization)
        }
        
        var custom: Selector {
            return #selector(customRequestWhenInUseAuthorization)
        }
    }
    
    internal struct RequestAuthorizationAlwaysMethod: ExchangableMethodImplementationProtocol {
        
        var original: Selector {
            return #selector(requestAlwaysAuthorization)
        }
        
        var custom: Selector {
            return #selector(customRequestAlwaysAuthorization)
        }
    }
    
    internal struct StartLocationUpdatesMethod: ExchangableMethodImplementationProtocol {
        
        var original: Selector {
            return #selector(startUpdatingLocation)
        }
        
        var custom: Selector {
            return #selector(customStartUpdatingLocation)
        }
    }
    
    internal struct StopLocationUpdatesMethod: ExchangableMethodImplementationProtocol {
        
        var original: Selector {
            return #selector(stopUpdatingLocation)
        }
        
        var custom: Selector {
            return #selector(customStopUpdatingLocation)
        }
    }
    
    internal struct LocationServicesEnabled: ExchangableMethodImplementationProtocol {
        
        var original: Selector {
            return #selector(CLLocationManager.locationServicesEnabled)
        }
        
        var custom: Selector {
            return #selector(CLLocationManager.customLocationServicesEnabled)
        }
    }
}


