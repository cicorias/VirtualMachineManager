import XCTest
@testable import VMManagerApp

class VMManagerTests: XCTestCase {
    var vmManager: VMManager!
    
    override func setUp() {
        super.setUp()
        vmManager = VMManager()
    }
    
    override func tearDown() {
        vmManager = nil
        super.tearDown()
    }
    
    func testCreateVM() {
        // Given
        let config = VMConfiguration(
            name: "Test VM",
            cpuCount: 2,
            memorySize: 2 * 1024 * 1024 * 1024,
            diskImagePath: "/path/to/disk.img",
            kernelPath: "/path/to/kernel",
            isLinux: true
        )
        
        // When
        let vm = vmManager.createVM(configuration: config)
        
        // Then
        XCTAssertEqual(vm.name, "Test VM")
        XCTAssertEqual(vm.configuration.cpuCount, 2)
        XCTAssertEqual(vm.configuration.memorySize, 2 * 1024 * 1024 * 1024)
        XCTAssertEqual(vm.status, .stopped)
        XCTAssertTrue(vmManager.virtualMachines.contains(where: { $0.id == vm.id }))
    }
    
    func testRemoveVM() {
        // Given
        let config = VMConfiguration(
            name: "Test VM",
            diskImagePath: "/path/to/disk.img",
            kernelPath: "/path/to/kernel"
        )
        let vm = vmManager.createVM(configuration: config)
        
        // When
        vmManager.removeVM(vm)
        
        // Then
        XCTAssertFalse(vmManager.virtualMachines.contains(where: { $0.id == vm.id }))
    }
    
    func testVMStatusEnumProperties() {
        // Test status display names
        XCTAssertEqual(VMStatus.running.displayName, "Running")
        XCTAssertEqual(VMStatus.stopped.displayName, "Stopped")
        XCTAssertEqual(VMStatus.paused.displayName, "Paused")
        
        // Test isActive property
        XCTAssertTrue(VMStatus.running.isActive)
        XCTAssertTrue(VMStatus.starting.isActive)
        XCTAssertFalse(VMStatus.stopped.isActive)
        XCTAssertFalse(VMStatus.paused.isActive)
    }
}
