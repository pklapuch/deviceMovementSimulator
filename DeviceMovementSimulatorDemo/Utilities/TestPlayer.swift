//
//  TestPlayer.swift
//  DeviceMovementSimulatorDemo
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import CoreLocation
import CoreMotion
import DeviceMovementSimulator

class TestPlayer: NSObject {
    private let queue = DispatchQueue(label: "queue")
    private var sourceTimer: DispatchSourceTimer?
    private var coordinate: CLLocationCoordinate2D
    private var isEnabled = false
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    func start() {
        queue.async {
            self.isEnabled = true
            self.startTimer()
        }
    }
    
    func stop() {
        queue.async {
            self.isEnabled = false
            self.stopTimer()
        }
    }
    
    private func updateState() {
        queue.async {
            if (self.isEnabled) {
                self.simulateNextItem()
            }
        }
    }
    
    private func simulateNextItem() {
        coordinate.latitude += 0.0001
        DeviceMovementSimulator.shared.simulate(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        DeviceMovementSimulator.shared.simulate(CMDeviceMotion.zero)
    }
    
    private func startTimer() {
        if (sourceTimer == nil) {
            sourceTimer = DispatchSource.makeTimerSource()
            sourceTimer?.schedule(deadline: .now(), repeating: .seconds(1))
            sourceTimer?.setEventHandler(handler: { [weak self] in
                self?.updateState()
            })
            sourceTimer?.activate()
        }
    }
    
    private func stopTimer() {
        sourceTimer?.cancel()
        sourceTimer = nil
    }
}
