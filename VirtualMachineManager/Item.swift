//
//  Item.swift
//  VirtualMachineManager
//
//  Created by Shawn Cicoria on 4/3/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
