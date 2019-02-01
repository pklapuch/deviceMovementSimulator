//
//  DeviceMotionExtensions.swift
//  DeviceMovementSimulatorDemo
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import CoreMotion

extension CMDeviceMotion {
    static var zero: CMDeviceMotion {
        return DeviceMotion(attitude: Attitude(roll: 0.0, pitch: 0.0, yaw: 0.0), rotationRate: CMRotationRate(x: 0.0, y: 0.0, z: 0.0), gravity: CMAcceleration(x: 0.0, y: 0.0, z: 0.0), userAcceleration: CMAcceleration(x: 0.0, y: 0.0, z: 0.0), magneticField: CMCalibratedMagneticField(field: CMMagneticField(x: 0.0, y: 0.0, z: 0.0), accuracy: .high), heading: 0)
    }
}

fileprivate class DeviceMotion: CMDeviceMotion {
    private var _attitude: CMAttitude
    private var _rotationRate: CMRotationRate
    private var _gravity: CMAcceleration
    private var _userAcceleration: CMAcceleration
    private var _magneticField: CMCalibratedMagneticField
    private var _heading: Double
    
    init(attitude: CMAttitude, rotationRate: CMRotationRate, gravity: CMAcceleration, userAcceleration: CMAcceleration, magneticField: CMCalibratedMagneticField, heading: Double) {
        _attitude = attitude
        _rotationRate = rotationRate
        _gravity = gravity
        _userAcceleration = userAcceleration
        _magneticField = magneticField
        _heading = heading
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        _attitude = Attitude(roll: 0.0, pitch: 0.0, yaw: 0.0)
        _rotationRate = CMRotationRate(x: 0.0, y: 0.0, z: 0.0)
        _gravity = CMAcceleration(x: 0.0, y: 0.0, z: 0.0)
        _userAcceleration = CMAcceleration(x: 0.0, y: 0.0, z: 0.0)
        _magneticField = CMCalibratedMagneticField(field: CMMagneticField(x: 0.0, y: 0.0, z: 0.0), accuracy: .high)
        _heading = 0
        super.init(coder: aDecoder)
    }
    
    override var attitude: CMAttitude {
        return _attitude
    }
    
    override var rotationRate: CMRotationRate {
        return _rotationRate
    }
    
    override var gravity: CMAcceleration {
        return _gravity
    }
    
    override var userAcceleration: CMAcceleration {
        return _userAcceleration
    }
    
    override var magneticField: CMCalibratedMagneticField {
        return _magneticField
    }
    
    override var heading: Double {
        return _heading
    }
}

fileprivate class Attitude: CMAttitude {
    var _roll: Double
    var _pitch: Double
    var _yaw: Double
    
    init(roll: Double, pitch: Double, yaw: Double) {
        _roll = roll
        _pitch = pitch
        _yaw = yaw
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        _roll = 0
        _pitch = 0
        _yaw = 0
        super.init(coder: aDecoder)
    }
    
    override var roll: Double {
        return _roll
    }
    
    override var pitch: Double {
        return _pitch
    }
    
    override var yaw: Double {
        return _yaw
    }
}
