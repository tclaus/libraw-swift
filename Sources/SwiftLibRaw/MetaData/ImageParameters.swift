//
//  ImageParameters.swift
//  SwiftLibRaw
//
//  Created by Thorsten Claus on 07.01.21.
//

import Foundation
import libraw

/// Meta Data about Camera and Image
public struct ImageParameters  {
    
    public let camera_manufacturer : String
    /// There is a huge number of identical cameras sold under different names, depending on the market (e.g. multiple Panasonic or Canon models) and even some identical cameras sold under different brands (Panasonic -> Leica, Sony -> Hasselblad). normalized_make contains primary vendor name (e.g. Panasonic for Leica re-branded cameras).
    public let camera_normalized_manufacturer : String
    
    public let camera_model : String
    /// Primary camera model name.
    public let camera_normalized_model : String
    
    /// Softwary name/version (mostly for DNG files, to distinguish in-camera DNGs from Adobe DNG Converter produced ones).
    public let software : String
    
    /// Number of RAW images in file (0 means that the file has not been recognized).
    public let raw_count : Int
    
    /// Number of colors in the file
    public let number_of_colors : Int
    
    /// Description of colors numbered from 0 to 3 (RGBG,RGBE,GMCY, or GBTG)
    public let color_description : String
    
    /// Nonzero for Sigma Foveon images
    public let isFOV_on : Int
    
    /*
     Bit mask describing the order of color pixels in the matrix (0 for full-color images). 32 bits of this field describe 16 pixels (8 rows with two pixels in each, from left to right and from top to bottom). Each two bits have values 0 to 3, which correspond to four possible colors. Convenient work with this field is ensured by the COLOR(row,column) function, which returns the number of the active color for a given pixel.
     Values less than 1000 are reserved as special cases:
     1 - Leaf Catchlight with 16x16 bayer matrix;
     9 - Fuji X-Trans (6x6 matrix)
     3..8 and 10..999 - are unused.
     */
    public var filters : Int
    
    /// These matrices contains Fuji X-Trans row/col to color mapping. Rrelative to visible area, while second is positioned relative to sensor edges.
    public var xtrans_6x6  : [UInt8] = Array(repeating: 0, count: 6 * 6)
    
    /// These matrices contains Fuji X-Trans row/col to color mapping. Rrelative to sensor edges.
    public var xtrans_abs_6x6 : [UInt8] = Array(repeating: 0, count: 6 * 6)
    
    
    init(parameters: libraw_iparams_t) {
        
        self.camera_manufacturer = withUnsafePointer(to: parameters.make) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
        
        self.camera_normalized_manufacturer = withUnsafePointer(to: parameters.normalized_make) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
        
        self.camera_model = withUnsafePointer(to: parameters.model) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
        
        self.camera_normalized_model = withUnsafePointer(to: parameters.normalized_model) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
        
        self.software = withUnsafePointer(to: parameters.software) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
        
        self.raw_count = Int(parameters.raw_count)
        self.number_of_colors = Int(parameters.colors)
        self.filters = Int(parameters.filters)
        
        self.color_description = withUnsafePointer(to: parameters.cdesc) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
        
        self.isFOV_on = Int(parameters.is_foveon)
        
        // 6x6 matrix
        self.xtrans_6x6 = withUnsafePointer(to: parameters.xtrans){
            $0.withMemoryRebound(to: UInt8.self, capacity: 36) {
                return [UInt8](UnsafeBufferPointer(start: $0, count: MemoryLayout.size(ofValue: parameters.xtrans)))
            }
        }
        // 6x6 Matrix
        self.xtrans_abs_6x6 = withUnsafePointer(to: parameters.xtrans_abs){
            $0.withMemoryRebound(to: UInt8.self, capacity: 36) {
                return [UInt8](UnsafeBufferPointer(start: $0, count: MemoryLayout.size(ofValue: parameters.xtrans_abs)))
            }
        }
    }
}

