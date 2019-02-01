//
//  ObjectExtensions.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import UIKit

extension NSObject {

    public class var nameOfClass: String {
        
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

    public class var nameOfClassWithPackageName: String {
        
        return NSStringFromClass(self)
    }
}
