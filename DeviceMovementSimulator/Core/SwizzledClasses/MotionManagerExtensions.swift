//
//  MotionManagerExtensions.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreMotion

internal protocol SwizzledMotionManagerProtocol: class {
    
    func swizzledMotionManagerDidStartDeviceMotionUpdatesWithHandler(_ handler:(CMDeviceMotionHandler?))
    func swizzledMotionManagerDidStopDeviceMotionUpdates()
    func swizzledMotionManagerDidRequestDeviceMotionData() -> CMDeviceMotion?
}

extension CMMotionManager {
    
    static weak var swizzleDelegate: SwizzledMotionManagerProtocol?
    internal(set) static var hasSwizzledMethods = false
    
    internal static func swizzleMethods() throws {
        
        guard !hasSwizzledMethods else { throw Error.simulatorAlreadyStarted }
        hasSwizzledMethods = true
        methods.forEach { Swizzle.swizzleInstance(CMMotionManager(), method: $0) }
    }
    
    internal static func unswizzleMethods() throws {
        
        guard hasSwizzledMethods else { throw Error.simulatorAlreadyStopped }
        hasSwizzledMethods = false
        methods.forEach { Swizzle.unswizzleInstance(CMMotionManager(), method: $0) }
    }
    
    fileprivate static let methods: [ExchangableMethodImplementationProtocol] = [
        
        Methods.startDeviceMotionUpdates,
        Methods.startDeviceMotionUpdatesWithHandler,
        Methods.deviceMotionData
    ]
}

extension CMMotionManager {
    
    @objc internal func customStartDeviceMotionUpdates() {
        
        CMMotionManager.swizzleDelegate?.swizzledMotionManagerDidStartDeviceMotionUpdatesWithHandler(nil)
    }
    
    @objc internal func customStartDeviceMotionUpdates(to queue: OperationQueue, withHandler handler: @escaping CMDeviceMotionHandler) {
        
        CMMotionManager.swizzleDelegate?.swizzledMotionManagerDidStartDeviceMotionUpdatesWithHandler(handler)
    }
    
    @objc internal var customDeviceMotionData: CMDeviceMotion? {
        
        return CMMotionManager.swizzleDelegate?.swizzledMotionManagerDidRequestDeviceMotionData()
    }
}
