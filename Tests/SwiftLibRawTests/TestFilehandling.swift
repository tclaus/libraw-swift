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
    
    // During Test its not the main bundle
    var testfilePath : URL! {
        get {
           let bundle = Bundle.init(for: TestFileHandling.self)
            return bundle.url(forResource: "Moon", withExtension: "RAF")!
        }
    }
    
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
    
    func testOpenAndUnpackFile() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(fileUrl: testfilePath,rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_SUCCESS)
        
        let unpackResult = FileHandling.unpackFile(rawdata: rawdata)
        XCTAssertEqual(unpackResult, LIBRAW_SUCCESS)
    }
    
    func testgetImageParameters() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(fileUrl: testfilePath,rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_SUCCESS)
        
        let imageData : ImageParameters = FileHandling.imageParameters(rawdata: rawdata)
        
        XCTAssertNotNil(imageData)
        XCTAssertEqual(imageData.camera_manufacturer, "Fujifilm")
        XCTAssertEqual(imageData.camera_model, "X-E2")
        
        XCTAssertNotNil(imageData.camera_normalized_model)
        XCTAssertNotNil(imageData.camera_normalized_manufacturer)
        XCTAssertTrue(imageData.number_of_colors > 0)
        XCTAssertTrue(imageData.raw_count > 0) // 0 means file could not be read
        XCTAssertNotNil(imageData.color_description)
        
        print("Camera: \(imageData.camera_manufacturer!) \(imageData.camera_model!)")
        print("Software: \(imageData.software!)")
        print("Filter: \(imageData.filters)")
        print("Number of colors: \(imageData.number_of_colors)")
        print("Color description: \(imageData.color_description)")
        print("Fuji Xtrans: \(imageData.xtrans_6x6)")
        print("Fuji Xtrans (Sensor-Edge relative): \(imageData.xtrans_abs_6x6)")
    }
    
}
