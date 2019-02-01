//
//  MotionManagerObservers.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation
import CoreMotion

internal class MotionManagerObservers: NSObject {
    
    private let queue = DispatchQueue(label: "\(productIdentifier).\(LocationManagerObservers.nameOfClass)")
    private var observers = [CMDeviceMotionHandler?]()
    
    internal func addHandler(_ handler: CMDeviceMotionHandler?) {
        
        queue.async {
            self.observers.append(handler)
        }
    }
    
    internal func notifyDeviceMotion(_ deviceMotion: CMDeviceMotion) {
        
        queue.async {
            self.observers.compactMap { $0 }.forEach { $0(deviceMotion, nil) }
        }
    }
    
    internal func reset() {
        
        queue.sync {
            self.observers.removeAll()
        }
    }
}
