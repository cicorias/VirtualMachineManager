import XCTest
@testable import VMManagerApp

class VMCreationViewModelTests: XCTestCase {
    var vmManager: VMManager!
    var viewModel: VMCreationViewModel!
    
    override func setUp() {
        super.setUp()
        vmManager = VMManager()
        viewModel = VMCreationViewModel(vmManager: vmManager)
    }
    
    override func tearDown() {
        viewModel = nil
        vmManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.name, "")
        XCTAssertEqual(viewModel.cpuCount, 2)
        XCTAssertEqual(viewModel.memorySizeGB, 2.0)
        XCTAssertEqual(viewModel.diskImagePath, "")
        XCTAssertEqual(viewModel.kernelPath, "")
        XCTAssertEqual(viewModel.ramdiskPath, "")
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFormValidation() {
        // Initially form should be invalid
        XCTAssertFalse(viewModel.isFormValid)
        
        // Set name only
        viewModel.name = "Test VM"
        XCTAssertFalse(viewModel.isFormValid)
        
        // Set disk image path
        viewModel.diskImagePath = "/path/to/disk.img"
        XCTAssertFalse(viewModel.isFormValid)
        
        // Set kernel path - now form should be valid
        viewModel.kernelPath = "/path/to/kernel"
        XCTAssertTrue(viewModel.isFormValid)
        
        // Test with invalid CPU count
        viewModel.cpuCount = 0
        XCTAssertFalse(viewModel.isFormValid)
        
        // Restore valid CPU count
        viewModel.cpuCount = 2
        XCTAssertTrue(viewModel.isFormValid)
        
        // Test with invalid memory size
        viewModel.memorySizeGB = 0.1
        XCTAssertFalse(viewModel.isFormValid)
        
        // Restore valid memory size
        viewModel.memorySizeGB = 2.0
        XCTAssertTrue(viewModel.isFormValid)
    }
    
    func testMemorySizeBytes() {
        viewModel.memorySizeGB = 1.0
        XCTAssertEqual(viewModel.memorySizeBytes, 1 * 1024 * 1024 * 1024)
        
        viewModel.memorySizeGB = 2.5
        XCTAssertEqual(viewModel.memorySizeBytes, 2.5 * 1024 * 1024 * 1024)
    }
    
    func testCreateVM() {
        // Setup valid form data
        viewModel.name = "Test VM"
        viewModel.cpuCount = 2
        viewModel.memorySizeGB = 2.0
        viewModel.diskImagePath = "/path/to/disk.img"
        viewModel.kernelPath = "/path/to/kernel"
        
        // Create VM
        let result = viewModel.createVM()
        
        // Verify result
        XCTAssertTrue(result)
        XCTAssertEqual(vmManager.virtualMachines.count, 1)
        XCTAssertEqual(vmManager.virtualMachines[0].name, "Test VM")
        XCTAssertEqual(vmManager.virtualMachines[0].configuration.cpuCount, 2)
        XCTAssertEqual(vmManager.virtualMachines[0].configuration.memorySize, 2 * 1024 * 1024 * 1024)
        XCTAssertEqual(vmManager.virtualMachines[0].configuration.diskImagePath, "/path/to/disk.img")
        XCTAssertEqual(vmManager.virtualMachines[0].configuration.kernelPath, "/path/to/kernel")
        XCTAssertNil(vmManager.virtualMachines[0].configuration.ramdiskPath)
    }
    
    func testReset() {
        // Setup some data
        viewModel.name = "Test VM"
        viewModel.cpuCount = 4
        viewModel.memorySizeGB = 4.0
        viewModel.diskImagePath = "/path/to/disk.img"
        viewModel.kernelPath = "/path/to/kernel"
        viewModel.ramdiskPath = "/path/to/ramdisk"
        viewModel.errorMessage = "Some error"
        
        // Reset
        viewModel.reset()
        
        // Verify reset state
        XCTAssertEqual(viewModel.name, "")
        XCTAssertEqual(viewModel.cpuCount, 2)
        XCTAssertEqual(viewModel.memorySizeGB, 2.0)
        XCTAssertEqual(viewModel.diskImagePath, "")
        XCTAssertEqual(viewModel.kernelPath, "")
        XCTAssertEqual(viewModel.ramdiskPath, "")
        XCTAssertNil(viewModel.errorMessage)
    }
}
