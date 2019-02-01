//
//  ExchangableMethodImplementationProtocol.swift
//  DeviceMovementSimulator
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import Foundation

internal protocol ExchangableMethodImplementationProtocol {
    var original: Selector { get }
    var custom: Selector { get }
}
