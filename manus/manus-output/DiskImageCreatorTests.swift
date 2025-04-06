import XCTest
@testable import VMManagerApp

class DiskImageCreatorTests: XCTestCase {
    
    func testCreateDiskImage() {
        // This is a mock test since we can't actually create disk images in the test environment
        // In a real implementation, we would use a mock file system or dependency injection
        
        do {
            // Setup temporary directory for test
            let tempDir = FileManager.default.temporaryDirectory
            let diskPath = tempDir.appendingPathComponent("test_disk.img").path
            
            // Test with valid size
            let url = try DiskImageCreator.createDiskImage(at: diskPath, sizeGB: 1.0)
            XCTAssertEqual(url.path, diskPath)
            
            // Clean up
            try? FileManager.default.removeItem(atPath: diskPath)
        } catch {
            XCTFail("Disk image creation should not fail: \(error)")
        }
    }
    
    func testCreateDiskImageWithInvalidSize() {
        // Test with invalid size
        let tempDir = FileManager.default.temporaryDirectory
        let diskPath = tempDir.appendingPathComponent("invalid_disk.img").path
        
        XCTAssertThrowsError(try DiskImageCreator.createDiskImage(at: diskPath, sizeGB: 0)) { error in
            XCTAssertTrue(error is DiskImageCreator.DiskImageError)
            if let diskError = error as? DiskImageCreator.DiskImageError {
                XCTAssertEqual(diskError, DiskImageCreator.DiskImageError.invalidSize)
            }
        }
    }
}
