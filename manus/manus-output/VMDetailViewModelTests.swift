import XCTest
@testable import VMManagerApp

class VMDetailViewModelTests: XCTestCase {
    var vmManager: VMManager!
    var vm: VirtualMachine!
    var viewModel: VMDetailViewModel!
    
    override func setUp() {
        super.setUp()
        vmManager = VMManager()
        
        let config = VMConfiguration(
            name: "Test VM",
            cpuCount: 4,
            memorySize: 4 * 1024 * 1024 * 1024,
            diskImagePath: "/path/to/disk.img",
            kernelPath: "/path/to/kernel",
            ramdiskPath: "/path/to/ramdisk",
            isLinux: true
        )
        
        vm = vmManager.createVM(configuration: config)
        viewModel = VMDetailViewModel(vm: vm, vmManager: vmManager)
    }
    
    override func tearDown() {
        viewModel = nil
        vm = nil
        vmManager = nil
        super.tearDown()
    }
    
    func testViewModelProperties() {
        // Test basic properties
        XCTAssertEqual(viewModel.name, "Test VM")
        XCTAssertEqual(viewModel.status, .stopped)
        XCTAssertEqual(viewModel.statusDisplayName, "Stopped")
        XCTAssertEqual(viewModel.cpuCount, 4)
        XCTAssertEqual(viewModel.memorySize, 4 * 1024 * 1024 * 1024)
        XCTAssertEqual(viewModel.memorySizeGB, 4.0)
        XCTAssertEqual(viewModel.diskImagePath, "/path/to/disk.img")
        XCTAssertEqual(viewModel.kernelPath, "/path/to/kernel")
        XCTAssertEqual(viewModel.ramdiskPath, "/path/to/ramdisk")
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testOperationAvailability() {
        // When VM is stopped
        vm.status = .stopped
        XCTAssertTrue(viewModel.canStart)
        XCTAssertFalse(viewModel.canStop)
        XCTAssertFalse(viewModel.canPause)
        XCTAssertFalse(viewModel.canResume)
        
        // When VM is running
        vm.status = .running
        XCTAssertFalse(viewModel.canStart)
        XCTAssertTrue(viewModel.canStop)
        XCTAssertTrue(viewModel.canPause)
        XCTAssertFalse(viewModel.canResume)
        
        // When VM is paused
        vm.status = .paused
        XCTAssertTrue(viewModel.canStart)
        XCTAssertTrue(viewModel.canStop)
        XCTAssertFalse(viewModel.canPause)
        XCTAssertTrue(viewModel.canResume)
    }
}
