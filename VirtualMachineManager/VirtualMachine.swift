//
//  VirtualMachine.swift
//  VirtualMachineManager
//
//  Created by Shawn Cicoria on 4/3/25.
//

import SwiftData
import Foundation

@Model
final class VirtualMachine: Identifiable {
    var id: UUID = UUID()
    var name: String
    var status: VMStatus
    var os: String
    var cpu: Int
    var ram: Int
    var disk: Int
    var snapshots: [String]
    
    init(name: String, status: VMStatus, os: String, cpu: Int, ram: Int, disk: Int, snapshots: [String]) {
        self.name = name
        self.status = status
        self.os = os
        self.cpu = cpu
        self.ram = ram
        self.disk = disk
        self.snapshots = snapshots
    }
    
    enum VMStatus: String, Codable, CaseIterable {
        case running, stopped, paused
        
        var badgeText: String {
            switch self {
            case .running:
                return "🟢 Running"
            case .stopped:
                return "🔴 Stopped"
            case .paused:
                return "🟡 Paused"
            }
        }
    }
}
