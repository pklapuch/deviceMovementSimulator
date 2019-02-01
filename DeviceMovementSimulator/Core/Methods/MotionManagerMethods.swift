//
//  MotionManagerMethods.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreMotion

extension CMMotionManager {
    
    internal struct Methods {
        
        static let startDeviceMotionUpdates = StartDeviceMotionUpdates()
        static let startDeviceMotionUpdatesWithHandler = StartDeviceMotionUpdatesWithHandler()
        static let deviceMotionData = DeviceMotionData()
    }
    
    internal struct StartDeviceMotionUpdates: ExchangableMethodImplementationProtocol {
        
        var original: Selector {
            return NSSelectorFromString("startDeviceMotionUpdates")
        }
        
        var custom: Selector {
            return NSSelectorFromString("customStartDeviceMotionUpdates")
        }
    }
    
    internal struct StartDeviceMotionUpdatesWithHandler: ExchangableMethodImplementationProtocol {
        
        var original: Selector {
            return #selector(CMMotionManager.startDeviceMotionUpdates(to:withHandler:))
        }
        
        var custom: Selector {
            return #selector(CMMotionManager.customStartDeviceMotionUpdates(to:withHandler:))
        }
    }
    
    internal struct DeviceMotionData: ExchangableMethodImplementationProtocol {
        
        var original: Selector {
            return #selector(getter: CMMotionManager.deviceMotion)
        }
        
        var custom: Selector {
            return #selector(getter: CMMotionManager.customDeviceMotionData)
        }
    }
}
