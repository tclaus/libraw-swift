import XCTest
@testable import SwiftLibRaw

final class librawTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(libraw().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
