//
//  TestMetadata.swift
//  SwiftLibRawTests
//
//  Created by Thorsten Claus on 08.01.21.
//

import XCTest
import Foundation
import libraw

class TestMetadata: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testgetImageParameters() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(fileUrl: testfilePath,rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_SUCCESS)
        
        let imageData : ImageParameters = ImageParameters(parameters: rawdata.pointee.idata)
        
        XCTAssertNotNil(imageData)
        XCTAssertEqual(imageData.camera_manufacturer, "Fujifilm")
        XCTAssertEqual(imageData.camera_model, "X-E2")
        
        XCTAssertNotNil(imageData.camera_normalized_model)
        XCTAssertNotNil(imageData.camera_normalized_manufacturer)
        XCTAssertTrue(imageData.number_of_colors > 0)
        XCTAssertTrue(imageData.raw_count > 0) // 0 means file could not be read
        XCTAssertEqual(imageData.color_description, "RGBG")
        
        print("Camera: \(imageData.camera_manufacturer) \(imageData.camera_model)")
        print("Software: \(imageData.software)")
        print("Filter: \(imageData.filters)")
        print("Number of colors: \(imageData.number_of_colors)")
        print("Color description: \(imageData.color_description)")
        print("Fuji Xtrans: \(imageData.xtrans_6x6)")
        print("Fuji Xtrans (Sensor-Edge relative): \(imageData.xtrans_abs_6x6)")
    }

    func testImageSizes() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(fileUrl: testfilePath,rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_SUCCESS)
        
        let imageSizes : ImageSizes = ImageSizes(sizes: rawdata.pointee.sizes)
        XCTAssertNotNil(imageSizes)
        
        XCTAssertEqual(imageSizes.heigth, 3296)
        XCTAssertEqual(imageSizes.width, 4934)
        XCTAssertEqual(imageSizes.raw_heigth, 4992)
        XCTAssertEqual(imageSizes.raw_width, 3296)
        XCTAssertEqual(imageSizes.top_margin, 0)
        XCTAssertEqual(imageSizes.left_margin, 6)
        XCTAssertEqual(imageSizes.iheight, 3296)
        XCTAssertEqual(imageSizes.iwidth, 4934)
        
        print("Image size: w/h \(imageSizes.width)x\(imageSizes.heigth)")
    }
    
    func testMetaInformation() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(fileUrl: testfilePath,rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_SUCCESS)
        
        let metaInformation = MetaDataInformation(rawdata)
        XCTAssertNotNil(metaInformation)
        XCTAssertNotNil(metaInformation.parameters)
        XCTAssertNotNil(metaInformation.sizes)
        XCTAssertNotNil(metaInformation.lensinfo)
        XCTAssertNotNil(metaInformation.otherInformation)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
