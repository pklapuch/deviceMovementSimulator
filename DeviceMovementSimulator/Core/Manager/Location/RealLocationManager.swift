//
//  RealLocationManager.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import CoreLocation

internal class RealLocationManager: NSObject {
    
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

    private let configuration: Configuration
    private var manager: CLLocationManager?
    private let queue = DispatchQueue(label: "\(productIdentifier).\(RealLocationManager.nameOfClass)")
    
    private var state: ManagerState = .idle
    private var locationServicesEnabled = false
    private var shouldTrackLocation = false
    
    private var authorizationType = AuthorizationType.unknown
    private var didRequestAuthorization = false
    
    private var processing = false
    private var hasQueuedUpdate = false
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    internal func start() {
        
        DispatchQueue.main.async {
            self.createInitialManager()
            self.queue.async {
                self.shouldTrackLocation = true
                self.updateState()
            }
        }
    }
    
    private func createInitialManager() {
        
        if (self.manager == nil) {
            self.manager = self.configuration.createLocationManager()
            self.manager?.realSetDelegate(self)
        }
    }
    
    internal func stop() {
        
        self.queue.async {
            self.shouldTrackLocation = false
            self.updateState()
        }
    }
    
    private func updateState() {
        
        DispatchQueue.main.async {
            self.locationServicesEnabled = CLLocationManager.realLocationServicesEnabled()
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
                    requestAuthorization(configuration.preferredAuthorization)
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
                self.manager?.realRequestAlwaysAuthorization()
            case .whenInUse:
                self.manager?.realRequestWhenInUseAuthorization()
            }
        }
    }
    
    private func startTrackingLocation(block:(()->())? = nil) {
        DispatchQueue.main.async {
            self.manager?.realStartUpdatingLocation()
            self.queue.async {
                block?()
            }
        }
    }
    
    private func stopTrackingLocation(block:(()->())? = nil) {
        DispatchQueue.main.async {
            self.manager?.realStopUpdatingLocation()
            self.queue.async {
                block?()
            }
        }
    }
}

extension RealLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // No action needed
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        queue.async {
            self.state = .idle
            self.authorizationType = status.authorizationType
            self.updateState()
        }
    }
}
