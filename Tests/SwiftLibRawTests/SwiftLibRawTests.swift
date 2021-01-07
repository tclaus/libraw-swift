import XCTest

final class SwiftLibRawTests: XCTestCase {
   
    func testGetVersion() {
        let libVersion = AuxiliaryFunctions.libVersion()
        XCTAssertTrue(libVersion.starts(with: "0.20"), "Expecting libraw version 0,20.x")
    }
    
    func testGetVersionNumber() {
        let libVersionNumber = AuxiliaryFunctions.libVersionNumber()
        XCTAssertTrue(libVersionNumber > 1)
    }
    
    func testGetSupportedCameraList() {
        let cameraList = AuxiliaryFunctions.cameraList()
        XCTAssertTrue(cameraList.count  > 1)
    }
    
    func testGetErrorCount() {
        let errorCount = AuxiliaryFunctions.errorCount()
        XCTAssertTrue(errorCount == 0)
    }

    static var allTests = [
        ("testGetVersion", testGetVersion),
    ]
}
