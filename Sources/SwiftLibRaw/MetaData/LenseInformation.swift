//
//  Lenses.swift
//  SwiftLibRaw
//
//  Created by Thorsten Claus on 07.01.21.
//

import Foundation
import libraw

/// The used lense.
/// In case the camera was used directly on a telescope, this information is zhe last known information the cam had
/// during the shot.
public struct LenseInformation {
    
    public let focalLengthIn35mmFormat : Int
    public let internalSerial : String
    public let serial: String
    
    ///  if not empty, contains the lens name present in Makernotes
    public let lens: String
    
    public let lensMake: String
    
    /// Contain the minimum and maximum focal lengths for the lens mounted on the camera.
    public let maxFocal, minFocal: Float
    
    /// if non-zero, contain maximum aperture available at minimal focal length, maximum aperture available at maximum focal length, minimum aperture available at minimal focal length, minimum aperture available at maximum focal length, respectively.
    public let maxAp4MinFocal, maxAp4MaxFocal : Float
    
    public init(lensInfo: libraw_lensinfo_t) {
        self.focalLengthIn35mmFormat =  Int(lensInfo.FocalLengthIn35mmFormat)
        
        self.internalSerial = withUnsafePointer(to: lensInfo.InternalLensSerial) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: lensInfo.InternalLensSerial)) {
                String(cString: $0)
            }
        }
        
        self.lens = withUnsafePointer(to: lensInfo.Lens) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: lensInfo.Lens)){
                String(cString: $0)
            }
        }
        
        self.lensMake = withUnsafePointer(to: lensInfo.LensMake) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: lensInfo.LensMake)){
                String(cString: $0)
            }
        }
        
        self.serial = withUnsafePointer(to: lensInfo.LensSerial) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: lensInfo.InternalLensSerial)) {
                String(cString: $0)
            }
        }
        self.maxFocal = lensInfo.MaxFocal
        self.minFocal = lensInfo.MinFocal
        
        self.maxAp4MaxFocal = lensInfo.MaxAp4MaxFocal
        self.maxAp4MinFocal = lensInfo.MaxAp4MinFocal
    }
}
