//
//  ImageSizes.swift
//  SwiftLibRaw
//
//  Created by Thorsten Claus on 07.01.21.
//

import Foundation
import libraw

/// The structure describes the geometrical parameters of the image.
public struct ImageSizes {
    
    /// Full size of RAW image (including the frame) in pixels.
   public let heigth, width : UInt16
    
    /// Size of visible ("meaningful") part of the image (without the frame).
    public let raw_heigth, raw_width : UInt16
    
    /// Coordinates of the top left corner of the frame (the second corner is calculated from the full size of the image and size of its visible part)
    public let top_margin, left_margin : UInt16
    
    /// Size of the output image (may differ from height/width for cameras that require image rotation or have non-square pixels).
    public let iheight, iwidth : UInt16
    
    /// Full size of raw data row in bytes
    public let raw_pitch : UInt32

    /// Pixel width/height ratio. If it is not unity, scaling of the image along one of the axes is required during output.
    public let pixel_aspect : Double

    /// Image orientation (0 if does not require rotation; 3 if requires 180-deg rotation; 5 if 90 deg counterclockwise, 6 if 90 deg clockwise).
    public let flip: Int
    
    public init(sizes: libraw_image_sizes_t) {
        heigth = sizes.height
        width = sizes.width
        
        raw_heigth = sizes.raw_width
        raw_width = sizes.raw_height
        
        top_margin = sizes.top_margin
        left_margin = sizes.left_margin
        
        iheight = sizes.iheight
        iwidth = sizes.iwidth
        
        raw_pitch = sizes.raw_pitch
        pixel_aspect = sizes.pixel_aspect
        
        flip = Int(sizes.flip) // TODO: Build as enum
    }
}
