//
//  LibRawData.swift
//  SwiftLibRaw
//
//  Created by Thorsten Claus on 25.12.20.
//

import Foundation
import libraw
import OSLog
import CoreLocation

class ImageProcessing {
    
    
    
    
    // Get an Image from RAW file
    public static func getImageFromData(_ rawdata: UnsafeMutablePointer<libraw_data_t>) -> String? {
        
        guard unpackFile(rawdata) == LIBRAW_SUCCESS else {
            return nil
        }
        
        guard rawToImage(rawdata) == LIBRAW_SUCCESS else {
            return nil
        }
        
        guard imageToMemory(rawdata) == LIBRAW_SUCCESS else {
            return nil
        }
        
        defer {
            libraw_recycle(rawdata);
            libraw_close(rawdata);
        }
        return "OK"
    }
    
    /// Unpacks the RAW files of the image, calculates the black level (not for all formats). The results are placed in imgdata.image.
    static func unpackFile(_ rawdata: UnsafeMutablePointer<libraw_data_t>) -> LibRaw_errors {
        let result = libraw_unpack(rawdata);
        
        if (result != LIBRAW_SUCCESS.rawValue) {
            if #available(OSX 11.0, *) {
                let defaultLog = Logger()
                let errorMessage = String(cString: libraw_strerror(result))
                defaultLog.log("LibRaw error: \(errorMessage)")
            }
            libraw_close(rawdata);
        }
        return LibRaw_errors.init(result)
    }
    
    /// Combines separate RGB layer to one
    static func rawToImage(_ rawdata: UnsafeMutablePointer<libraw_data_t>) -> LibRaw_errors {
        
        let result = libraw_raw2image(rawdata)
        
        if (result != LIBRAW_SUCCESS.rawValue) {
            if #available(OSX 11.0, *) {
                let defaultLog = Logger()
                let errorMessage = String(cString: libraw_strerror(result))
                defaultLog.log("LibRaw error: \(errorMessage)")
            }
            libraw_recycle(rawdata);
            libraw_close(rawdata);
        }
        return LibRaw_errors.init(result)
    }
    
    static func  process(_ rawdata: UnsafeMutablePointer<libraw_data_t>) -> LibRaw_errors {
        let result = libraw_dcraw_process(rawdata);
        if (result != LIBRAW_SUCCESS.rawValue) {
            if #available(OSX 11.0, *) {
                let defaultLog = Logger()
                let errorMessage = String(cString: libraw_strerror(result))
                defaultLog.log("LibRaw error: \(errorMessage)")
            }
            libraw_free_image(rawdata);
            libraw_recycle(rawdata);
            libraw_close(rawdata);
        }
        return LibRaw_errors.init(result)
    }
    
    static func imageToMemory(_ rawdata : UnsafeMutablePointer<libraw_data_t>) -> LibRaw_errors {
        var result : Int32 = 0
        let imageData = rawdata.pointee.image
        let imageDataPointee1 = imageData?.pointee
        
        let processedImage = libraw_dcraw_make_mem_image(rawdata, &result);

        let imageDataPointee2 = imageData?.pointee
        
        if (processedImage == nil) {
            if #available(OSX 11.0, *) {
                let defaultLog = Logger()
                let errorMessage = String(cString: libraw_strerror(result))
                defaultLog.log("LibRaw error: \(errorMessage)")
            }
            
            libraw_recycle(rawdata);
            libraw_close(rawdata);
        }
    
        if let data = processedImage?.pointee {
            let heigth = Int(data.height)
            let width = Int(data.width)
            let numberOfComponents = 3
            let numBytes = heigth * width * numberOfComponents
            let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
            
            let dataPointer = withUnsafePointer(to: data.data) {
                $0.withMemoryRebound(to: UInt8.self, capacity: Int(data.data_size)){
                    return UnsafePointer($0)
                }
            }
            
            let rgbData = CFDataCreate(nil, dataPointer, Int(data.data_size))!
            let provider = CGDataProvider(data: rgbData)!
            
            let rgbImageRef = CGImage(width: width,
                                      height: heigth,
                                      bitsPerComponent: Int(data.bits),
                                      bitsPerPixel: Int(data.bits) *  3,
                                      bytesPerRow: width * numberOfComponents,
                                      space: colorSpace,
                                      bitmapInfo: CGBitmapInfo(),
                                      provider: provider,
                                      decode: nil,
                                      shouldInterpolate: true,
                                      intent: CGColorRenderingIntent.defaultIntent)
            
            if (rgbImageRef == nil) {
                return LIBRAW_DATA_ERROR
            }
            
        }
        
        
        return LibRaw_errors.init(result)
    }
    
}
