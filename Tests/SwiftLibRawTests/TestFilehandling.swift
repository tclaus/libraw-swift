//
//  TestFilehandling.swift
//  SwiftLibRaw
//
//  Created by Thorsten Claus on 24.12.20.
//
import XCTest
import Foundation
import libraw


class TestFileHandling : XCTestCase {
    
    let testfilePath = "/Users/thorstenclaus/Pictures/Mond_nov_2020/Moon.RAF"
   
    func testOpenFile_notFound() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(filePath: "",rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_IO_ERROR)
    }
    
    func testOpenFile() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(filePath: testfilePath,rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_SUCCESS)
        let unfold = rawdata.pointee
        
        print("Image Data: Height: \(unfold.sizes.height), Width: \(unfold.sizes.width)")
        print("Image Make: \(unfold.idata.make)")
    }
    
    func testOpenAndUnpackFile() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(filePath: testfilePath,rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_SUCCESS)
        
        let unpackResult = FileHandling.unpackFile(rawdata: rawdata)
        XCTAssertEqual(unpackResult, LIBRAW_SUCCESS)
        
    }
    
}
