//
//  DeviceMotionUtilities.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 01/02/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import CoreMotion

@objc(DMSDeviceMotionUtilities)
public class DeviceMotionUtilities: NSObject {
    
    @objc(createEmptyDeviceMotion)
    public static func createEmptyDeviceMotion() -> CMDeviceMotion {
        return CMDeviceMotion.zero
    }
    
    @objc(createAttitudeWithRoll:pitch:yaw:)
    public static func createAttitudeWith(roll: Double, pitch: Double, yaw: Double) -> CMAttitude {
        
        let attitude = CMAttitude.Attitude()
        attitude.rollValue = roll
        attitude.pitchValue = pitch
        attitude.yawValue = yaw
        
        return attitude
    }
}

@objc(DMSDeviceMotionBuilder)
public class DeviceMotionBuilder: NSObject {
    
    fileprivate let deviceMotion: CMDeviceMotion.DeviceMotion
    
    public override init() {
        
        deviceMotion = CMDeviceMotion.DeviceMotion()
    }
    
    @objc(setAttitude:)
    public func setAttitude(_ attitude: CMAttitude) {
        
        deviceMotion.attitudeValue = attitude
    }
    
    @objc(setRotationRate:)
    public func setRotationRate(_ rotationRate: CMRotationRate) {
        
        deviceMotion.rotationValue = rotationRate
    }
    
    @objc(setGravity:)
    public func setGravity(_ gravity: CMAcceleration) {
        
        deviceMotion.gravityValue = gravity
    }
    
    @objc(setUserAcceleration:)
    public func setUserAcceleration(_ userAcceleration: CMAcceleration) {
        
        deviceMotion.userAccelerationValue = userAcceleration
    }
    
    @objc(setMagneticField:)
    public func setMagneticField(_ magneticField: CMCalibratedMagneticField) {
        
        deviceMotion.magneticFieldValue = magneticField
    }
    
    @objc(setHeading:)
    public func setHeading(_ heading: Double) {
        
        deviceMotion.headingValue = heading
    }
    
    public func build() -> CMDeviceMotion {
        
        return deviceMotion
    }
}

internal extension CMDeviceMotion {
    
    internal static var zero: CMDeviceMotion {
        return DeviceMotion()
    }
    
    internal class DeviceMotion: CMDeviceMotion {
        
        var attitudeValue = CMAttitude.zero
        var rotationValue = CMRotationRate.zero
        var gravityValue = CMAcceleration.zero
        var userAccelerationValue = CMAcceleration.zero
        var magneticFieldValue = CMCalibratedMagneticField.zero
        var headingValue: Double = 0
        
        override init() {
            super.init()
        }
        
        init(attitude: CMAttitude, rotation: CMRotationRate, gravity: CMAcceleration, userAcceleration: CMAcceleration, magneticField: CMCalibratedMagneticField, heading: Double) {
            self.attitudeValue = attitude
            self.rotationValue = rotation
            self.gravityValue = gravity
            self.userAccelerationValue = userAcceleration
            self.magneticFieldValue = magneticField
            self.headingValue = heading
            super.init()
        }
        
        internal required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        internal override var attitude: CMAttitude {
            return attitudeValue
        }
        
        internal override var rotationRate: CMRotationRate {
            return rotationValue
        }
        
        internal override var gravity: CMAcceleration {
            return gravityValue
        }
        
        internal override var userAcceleration: CMAcceleration {
            return userAccelerationValue
        }
        
        internal override var magneticField: CMCalibratedMagneticField {
            return magneticFieldValue
        }
        
        internal override var heading: Double {
            return headingValue
        }
    }
}

internal extension CMAttitude {
    
    internal static var zero: CMAttitude {
        return Attitude()
    }
    
    fileprivate class Attitude: CMAttitude {
        
        var rollValue: Double = 0.0
        var pitchValue: Double = 0.0
        var yawValue: Double = 0.0
        
        override init() {
            super.init()
        }
        
        init(roll: Double, pitch: Double, yaw: Double) {
            self.rollValue = roll
            self.pitchValue = pitch
            self.yawValue = yaw
            super.init()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override var roll: Double {
            return rollValue
        }
        
        override var pitch: Double {
            return pitchValue
        }
        
        override var yaw: Double {
            return yawValue
        }
    }
}

internal extension CMRotationRate {
    
    internal static var zero: CMRotationRate {
        return CMRotationRate(x: 0.0, y: 0.0, z: 0.0)
    }
}

internal extension CMAcceleration {
    
    internal static var zero: CMAcceleration {
        return CMAcceleration(x: 0.0, y: 0.0, z: 0.0)
    }
}

internal extension CMCalibratedMagneticField {
    
    internal static var zero: CMCalibratedMagneticField {
        let magneticField = CMMagneticField(x: 0.0, y: 0.0, z: 0.0)
        return CMCalibratedMagneticField(field: magneticField, accuracy: .high)
    }
}
