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
    
    public static var zero: CMDeviceMotion {
        return CMDeviceMotion.zero
    }
    
    public static func createWith(attitude: CMAttitude? = nil, rotationRate: CMRotationRate? = nil, gravity: CMAcceleration? = nil,  userAcceleration: CMAcceleration? = nil,  magneticFieldValue: CMCalibratedMagneticField? = nil, heading: Double? = nil) -> CMDeviceMotion {
        
        let deviceMotion = CMDeviceMotion.DeviceMotion()
        deviceMotion.attitudeValue = attitude ?? CMAttitude.zero
        deviceMotion.rotationValue = rotationRate ?? CMRotationRate.zero
        deviceMotion.gravityValue = gravity ?? CMAcceleration.zero
        deviceMotion.userAccelerationValue = userAcceleration ?? CMAcceleration.zero
        deviceMotion.magneticFieldValue = magneticFieldValue ?? CMCalibratedMagneticField.zero
        deviceMotion.headingValue = heading ?? 0.0
        
        return deviceMotion
    }
    
    public static func createAttitude(roll: Double, pitch: Double, yaw: Double) -> CMAttitude {
        
        let attitude = CMAttitude.Attitude()
        attitude.rollValue = roll
        attitude.pitchValue = pitch
        attitude.yawValue = yaw
        
        return attitude
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
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override var attitude: CMAttitude {
            return attitudeValue
        }
        
        override var rotationRate: CMRotationRate {
            return rotationValue
        }
        
        override var gravity: CMAcceleration {
            return gravityValue
        }
        
        override var userAcceleration: CMAcceleration {
            return userAccelerationValue
        }
        
        override var magneticField: CMCalibratedMagneticField {
            return magneticFieldValue
        }
        
        override var heading: Double {
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
