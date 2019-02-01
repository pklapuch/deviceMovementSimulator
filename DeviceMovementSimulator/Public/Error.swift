//
//  Error.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 01/02/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation

public enum Error: CustomNSError {
    
    case alreadyEnabled
    case alreadyDisabled
    
    public static var errorDomain: String { return productDomain }
    
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: "Forbidden action",
                NSLocalizedFailureReasonErrorKey: "Make sure to always disable SDK (if already enabled) before enabling it again!"]
    }
}
