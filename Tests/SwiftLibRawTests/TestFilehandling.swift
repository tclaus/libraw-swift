//
//  TestFilehandling.swift
//  SwiftLibRaw
//
//  Created by Thorsten Claus on 24.12.20.
//
import XCTest
import Foundation
import libraw

// Some cool tips here:
// http://olegkutkov.me/2018/05/16/converting-dslr-raw-images-into-scientific-fits-format-part-2-working-with-libraw/

class TestFileHandling : XCTestCase {
    

    func testOpenFile_notFound() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(fileUrl: URL(fileURLWithPath: ""),rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_IO_ERROR)
    }
    
    func testOpenFile() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(fileUrl: testfilePath,rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_SUCCESS)
        let unfold = rawdata.pointee
        
        print("Image Data: Height: \(unfold.sizes.height), Width: \(unfold.sizes.width)")
        print("Image Make (raw values): \(unfold.idata.make)")
    }
            
}
