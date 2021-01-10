//
//  TestImageProcessing.swift
//  SwiftLibRawTests
//
//  Created by Thorsten Claus on 09.01.21.
//

import XCTest
import Foundation
import libraw

class TestImageProcessing : XCTestCase {
    
    func testOpenAndUnpackFile() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(fileUrl: testfilePath,rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_SUCCESS)
        
        let unpackResult = ImageProcessing.getImageFromData(rawdata)
        XCTAssertNotNil(unpackResult)
    }
}
