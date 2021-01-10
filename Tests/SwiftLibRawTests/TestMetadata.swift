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
    
    func testOtherImageInformation() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(fileUrl: testfilePath,rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_SUCCESS)
        
        let otherInformation : ImageOtherInformation = ImageOtherInformation(otherInformation: rawdata.pointee.other)
        
        XCTAssertTrue(otherInformation.analogBalance.count > 0)
        XCTAssertTrue(otherInformation.aperture > 0)
        XCTAssertTrue(otherInformation.focal_length > 0 )
        XCTAssertTrue(otherInformation.iso_speed == 200 )
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: otherInformation.shooted_at)
        
        // Test picture was shooted at 2020
        XCTAssertTrue(year == 2020)
        XCTAssertTrue( otherInformation.shot_order == 0)
        XCTAssertTrue(otherInformation.shutter >= 0.002) // 1/500
        XCTAssertEqual(otherInformation.shutter_in_fractions,"1/500")
        
        print("Apertue: \(otherInformation.aperture)")
        print("Focal Length: \(otherInformation.focal_length)")
        print("ISO: \(otherInformation.iso_speed)")
        print("Exposure Time: \(otherInformation.shutter_in_fractions)")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let formattedDate = dateFormatter.string(from: otherInformation.shooted_at)
        print("Shooto at: \(formattedDate)")
    }
    
    func testLensInformation() {
        let rawdata = libraw_init(0)!;
        let fileOpenresult = FileHandling.openFile(fileUrl: testfilePath,rawdata: rawdata)
        XCTAssertEqual(fileOpenresult, LIBRAW_SUCCESS)
        
        let lensInformation = LenseInformation(lensInfo: rawdata.pointee.lens)
        XCTAssertEqual(lensInformation.focalLengthIn35mmFormat, 84)
        XCTAssertEqual(lensInformation.maxFocal, 56) // Foto was shot with fixed lense
        XCTAssertEqual(lensInformation.minFocal, 56)
        
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
