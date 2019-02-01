//
//  MovementDataView.swift
//  DeviceMovementSimulatorDemo
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class MovementDataView: UIView {
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var accelerationLabel: UILabel!
    @IBOutlet weak var rotationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        refreshLocation()
        refreshDeviceMotion()
    }
    
    var location: CLLocation? {
        didSet {
            refreshLocation()
        }
    }
    
    var deviceMotion: CMDeviceMotion? {
        didSet {
            refreshDeviceMotion()
        }
    }
    
    private func refreshLocation() {
        if let location = location {
            latitudeLabel.text = "Latitude: \(location.coordinate.latitude)"
            longitudeLabel.text = "Longitude: \(location.coordinate.longitude)"
        } else {
            latitudeLabel.text = "Latitude: --"
            longitudeLabel.text = "Longitude: --"
        }
    }
    
    private func refreshDeviceMotion() {
        if let deviceMotion = deviceMotion {
            accelerationLabel.text = "Acceleration: \(deviceMotion.userAcceleration.x) | \(deviceMotion.userAcceleration.y) | \(deviceMotion.userAcceleration.z)"
            rotationLabel.text = "Rotation: \(deviceMotion.rotationRate.x) | \(deviceMotion.rotationRate.y) | \(deviceMotion.rotationRate.z)"
        } else {
            accelerationLabel.text = "Acceleration: --"
            rotationLabel.text = "Rotation: --"
        }
    }
}
