//
//  ImageOtherInformation.swift
//  SwiftLibRaw
//
//  Created by Thorsten Claus on 08.01.21.
//

import Foundation
import libraw

/// Other image information like ISO, Aperture, Shutter Time
public struct ImageOtherInformation {
    
    public let analogBalance : [Float]
    
    /// ISO sensitivity.
    public let iso_speed : Float
    
    /// Shutter speed in seconds
    public let shutter : Float
    
    /// Aperture
    public let aperture: Float
    
    public let description: String
    ///Focal length
    public let focal_length: Float
    
    /// Date of shooting.
    public let shooted_at: Date
    
    /// Serial number of image.
    public let shot_order : Int
    
    /// GPS data (unparsed block, to write to output as is).
    // public let unsigned gpsdata[32]
    
    /// Parsed GPS-data: longitude/latitude/altitude and time stamp.
    // libraw_gps_info_t parsed_gps;
    // char desc[512];
    
    /// Author of image.
    public let artist : String
    
    
    init(otherInformation: libraw_imgother_t) {
        
        analogBalance = withUnsafePointer(to: otherInformation.analogbalance){
            $0.withMemoryRebound(to: Float.self, capacity: 36) {
                return [Float](UnsafeBufferPointer(start: $0, count: MemoryLayout.size(ofValue: otherInformation.analogbalance)))
            }
        }
        
        aperture = otherInformation.aperture
        artist = withUnsafePointer(to: otherInformation.artist) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
        
        description = withUnsafePointer(to: otherInformation.desc) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
        
        focal_length = otherInformation.focal_len
        
        // TODO: Implement detailed GPS Data
        // otherInformation.parsed_gps
        // otherInformation.gpsdata
        
        iso_speed = Float(otherInformation.iso_speed)
        shot_order = Int(otherInformation.shot_order)
        shutter = otherInformation.shutter
        shooted_at = Date(timeIntervalSince1970: Double(otherInformation.timestamp))
    }
}
