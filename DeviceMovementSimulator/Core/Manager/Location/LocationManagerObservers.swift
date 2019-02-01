//
//  LocationManagerObservers.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import CoreLocation

internal class Observer: NSObject {
    weak var manager: CLLocationManager?
    weak var delegate: CLLocationManagerDelegate?
    
    init(manager: CLLocationManager?, delegate: CLLocationManagerDelegate?) {
        self.manager = manager
        self.delegate = delegate
    }
}

internal class LocationManagerObservers: NSObject {
    
    private let queue = DispatchQueue(label: "\(productIdentifier).\(LocationManagerObservers.nameOfClass)")
    private var observers = [ObjectIdentifier : Observer]()
    
    internal func addObserverWithDelegate(_ delegate: CLLocationManagerDelegate, manager: CLLocationManager) {
        queue.sync {
            let observerID = ObjectIdentifier(manager)
            self.observers[observerID] = Observer(manager: manager, delegate: delegate)
        }
    }
    
    internal func removeObserverWithManager(_ manager: CLLocationManager) {
        queue.sync {
            let observerID = ObjectIdentifier(manager)
            self.observers[observerID] = nil
        }
    }
    
    internal func notifyLocation(_ location: CLLocation) {
        queue.sync {
            let activeObservers = self.observers.filter { $0.value.manager != nil }
            DispatchQueue.main.async {
                activeObservers.forEach { $0.value.delegate?.locationManager?($0.value.manager!, didUpdateLocations: [location]) }
            }
        }
    }
    
    internal func notifyAuthorizationStatus(_ status: CLAuthorizationStatus) {
        queue.sync {
            let activeObservers = self.observers.filter { $0.value.manager != nil }
            DispatchQueue.main.async {
                activeObservers.forEach { $0.value.delegate?.locationManager?($0.value.manager!, didChangeAuthorization: status) }
            }
        }
    }
    
    internal func reset() {
        
        queue.sync {
            self.observers.removeAll()
        }
    }
}
