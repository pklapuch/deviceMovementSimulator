//
//  DefaultLocationManager.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import CoreLocation

internal protocol DefaultLocationManagerProtocol: class {
    func defaultLocationManagerDidStartTrackingLocation(_ manager: DefaultLocationManager)
}

internal class DefaultLocationManager: NSObject {
    
    fileprivate enum ManagerState {
        case idle
        case waitingForAuthorization
        case tracking
    }
    
    internal enum AuthorizationType   {
        case unknown
        case denied
        case whenInUse
        case always
    }

    private let manager: CLLocationManager
    private let queue = DispatchQueue(label: "\(productIdentifier).\(DefaultLocationManager.nameOfClass)")
    internal weak var delegate: DefaultLocationManagerProtocol?
    
    private var state: ManagerState = .idle
    private var locationServicesEnabled = false
    private var shouldTrackLocation = false
    
    private var preferredAuthorizationType: RequestAuthorization
    private var authorizationType = AuthorizationType.unknown
    private var didRequestAuthorization = false
    
    private var processing = false
    private var hasQueuedUpdate = false
    
    init(configuration: Configuration, delegate: DefaultLocationManagerProtocol) {
        
        self.manager = configuration.createLocationManager()
        self.preferredAuthorizationType = configuration.preferredAuthorization
        self.delegate = delegate
    }
    
    internal func start() {
        
        queue.async {
            self.manager.delegate = self
            self.shouldTrackLocation = true
            self.updateState()
        }
    }
    
    internal func stop() {
        
        queue.async {
            self.manager.delegate = nil
            self.shouldTrackLocation = false
            self.updateState()
        }
    }
    
    private func updateState() {
        
        DispatchQueue.main.async {
            self.locationServicesEnabled = CLLocationManager.locationServicesEnabled()
            self.queue.async {
                self.processNextState()
            }
        }
    }
    
    private func processNextState() {
        switch state {
        case .idle:
            onIdle()
        case .waitingForAuthorization:
            unlockProcessing(shouldProcessQueuedState: true)
        case .tracking:
            onTracking()
        }
    }
    
    private func onIdle() {
        if (shouldTrackLocation) {
            guard locationServicesEnabled else {
                unlockProcessing(shouldProcessQueuedState: true)
                return
            }

            switch authorizationType {
            case .unknown:
                if (!didRequestAuthorization) {
                    unlockProcessing(shouldProcessQueuedState: false)
                    didRequestAuthorization = true
                    state = .waitingForAuthorization
                    requestAuthorization(preferredAuthorizationType)
                } else {
                    unlockProcessing(shouldProcessQueuedState: true)
                }
            case .denied:
                unlockProcessing(shouldProcessQueuedState: true)
            default:
                startTrackingLocation {
                    self.state = .tracking
                    self.unlockProcessing(shouldProcessQueuedState: true)
                }
            }
        } else {
            unlockProcessing(shouldProcessQueuedState: true)
        }
    }
    
    private func onTracking() {
        if (!shouldTrackLocation) {
            stopTrackingLocation {
                self.state = .idle
                self.unlockProcessing(shouldProcessQueuedState: true)
            }
        } else {
            unlockProcessing(shouldProcessQueuedState: true)
        }
    }
    
    private func unlockProcessing(shouldProcessQueuedState: Bool) {
        queue.async {
            self.processing = false
            if (self.hasQueuedUpdate && shouldProcessQueuedState) {
                self.hasQueuedUpdate = false
                self.updateState()
            }
        }
    }
    
    private func requestAuthorization(_ authorization: RequestAuthorization) {
        DispatchQueue.main.async {
            switch authorization {
            case .always:
                self.manager.requestAlwaysAuthorization()
            case .whenInUse:
                self.manager.requestWhenInUseAuthorization()
            }
        }
    }
    
    private func startTrackingLocation(block:(()->())? = nil) {
        DispatchQueue.main.async {
            self.manager.startUpdatingLocation()
            self.queue.async {
                self.delegate?.defaultLocationManagerDidStartTrackingLocation(self)
                block?()
            }
        }
    }
    
    private func stopTrackingLocation(block:(()->())? = nil) {
        DispatchQueue.main.async {
            self.manager.stopUpdatingLocation()
            self.queue.async {
                block?()
            }
        }
    }
}

extension DefaultLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // No action needed
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        queue.async {
            self.authorizationType = status.authorizationType
            self.updateState()
        }
    }
}

extension DefaultLocationManager {
    
    var isTrackingPossible: Bool {
        get {
            var state = false
            queue.sync {
                // NOTE: If authorizationType == .denied => not possible
                // NOTE: If authorizationType == .unknown -> we can assume that it's possible to track location
                // In worst case 'request authorization' will return 'denied' state which will be handled
                
                if (self.authorizationType != .denied) {
                    
                    let dispatchGroup = DispatchGroup()
                    dispatchGroup.enter()
                    
                    DispatchQueue.main.async {
                        state = CLLocationManager.locationServicesEnabled()
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.wait()
                }
            }
            
            return state
        }
    }
}
