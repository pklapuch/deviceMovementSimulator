//
//  ViewPresenter.swift
//  DeviceMovementSimulatorDemo
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion
import DeviceMovementSimulator

protocol ViewPresenterProtocol: class {
    func viewPresenterRefresh(_ presenter: ViewPresenter)
}

class ViewPresenter: NSObject {
    weak var delegate: ViewPresenterProtocol?
    private var locationManager: CLLocationManager?
    private var motionManager: CMMotionManager?
    private var testPlayer: TestPlayer
    
    private(set) var isSimulating = false
    private(set) var currentLocation: CLLocation?
    private(set) var currentDeviceMotion: CMDeviceMotion?
    
    override init() {
        testPlayer = TestPlayer(coordinate: CLLocationCoordinate2D(latitude: 49, longitude: 12))
    }
    
    func toggleSimulation() {
        isSimulating.toggle()
        delegate?.viewPresenterRefresh(self)
        
        if (isSimulating) {
            startSimulation()
            startTracking()
            testPlayer.start()
            
        } else {
            stopSimulation()
            testPlayer.stop()
        }
    }
    
    private func startSimulation() {
        let configuration = Configuration(simulateBackgroundUpdates: false)
        try! DeviceMovementSimulator.shared.enableWith(configuration)
    }
    
    private func startTracking() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        
        motionManager = CMMotionManager()
        motionManager?.startDeviceMotionUpdates()
    }
    
    private func stopTracking() {
        locationManager?.stopUpdatingLocation()
        motionManager?.stopDeviceMotionUpdates()
    }
    
    private func stopSimulation() {
        try! DeviceMovementSimulator.shared.disable()
    }
}

extension ViewPresenter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.currentLocation = locations.last
            self.currentDeviceMotion = self.motionManager?.deviceMotion
            self.delegate?.viewPresenterRefresh(self)
        }
    }
}

