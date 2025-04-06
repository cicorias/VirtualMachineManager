import XCTest
@testable import VMManagerApp

class VMOperationManagerTests: XCTestCase {
    var vm: VirtualMachine!
    
    override func setUp() {
        super.setUp()
        
        let config = VMConfiguration(
            name: "Test VM",
            cpuCount: 2,
            memorySize: 2 * 1024 * 1024 * 1024,
            diskImagePath: "/path/to/disk.img",
            kernelPath: "/path/to/kernel",
            isLinux: true
        )
        
        vm = VirtualMachine(configuration: config)
    }
    
    override func tearDown() {
        vm = nil
        super.tearDown()
    }
    
    func testStartVMValidation() {
        // Test starting a VM that's already running
        vm.status = .running
        
        var expectation = XCTestExpectation(description: "Start VM validation")
        
        VMOperationManager.startVM(vm) { result in
            switch result {
            case .success:
                XCTFail("Should not succeed when VM is already running")
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription.contains("VM must be stopped or paused to start"))
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Test starting a VM that's stopped
        vm.status = .stopped
        
        // We can't fully test the start operation without a real VM,
        // but we can verify the status changes to starting
        VMOperationManager.startVM(vm) { _ in }
        XCTAssertEqual(vm.status, .starting)
    }
    
    func testStopVMValidation() {
        // Test stopping a VM that's already stopped
        vm.status = .stopped
        
        var expectation = XCTestExpectation(description: "Stop VM validation")
        
        VMOperationManager.stopVM(vm) { result in
            switch result {
            case .success:
                XCTFail("Should not succeed when VM is already stopped")
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription.contains("VM must be running or paused to stop"))
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Test stopping a VM that's running
        vm.status = .running
        
        // We can't fully test the stop operation without a real VM,
        // but we can verify the status changes to shuttingDown
        VMOperationManager.stopVM(vm) { _ in }
        XCTAssertEqual(vm.status, .shuttingDown)
    }
    
    func testPauseVMValidation() {
        // Test pausing a VM that's not running
        vm.status = .stopped
        
        var expectation = XCTestExpectation(description: "Pause VM validation")
        
        VMOperationManager.pauseVM(vm) { result in
            switch result {
            case .success:
                XCTFail("Should not succeed when VM is not running")
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription.contains("VM must be running to pause"))
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Test pausing a VM that's running
        vm.status = .running
        
        // We can't fully test the pause operation without a real VM,
        // but we can verify the status changes to pausing
        VMOperationManager.pauseVM(vm) { _ in }
        XCTAssertEqual(vm.status, .pausing)
    }
    
    func testResumeVMValidation() {
        // Test resuming a VM that's not paused
        vm.status = .stopped
        
        var expectation = XCTestExpectation(description: "Resume VM validation")
        
        VMOperationManager.resumeVM(vm) { result in
            switch result {
            case .success:
                XCTFail("Should not succeed when VM is not paused")
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription.contains("VM must be paused to resume"))
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Test resuming a VM that's paused
        vm.status = .paused
        
        // We can't fully test the resume operation without a real VM,
        // but we can verify the status changes to resuming
        VMOperationManager.resumeVM(vm) { _ in }
        XCTAssertEqual(vm.status, .resuming)
    }
}
