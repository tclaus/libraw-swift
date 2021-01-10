//
//  MetaDataInformation.swift
//  SwiftLibRaw
//
//  Created by Thorsten Claus on 07.01.21.
//

import Foundation
import libraw

/// Collects all metadata from raw data object
public struct MetaDataInformation {
    public let lensinfo : LenseInformation
    public let sizes : ImageSizes
    public let parameters : ImageParameters
    public let otherInformation : ImageOtherInformation
    
    /// Creates a new object with data from already opened image
    public init(_ rawdata: UnsafeMutablePointer<libraw_data_t>) {
        let data = rawdata.pointee
        self.lensinfo = LenseInformation(lensInfo: data.lens)
        self.sizes = ImageSizes(sizes: data.sizes)
        self.parameters = ImageParameters(parameters: data.idata)
        self.otherInformation = ImageOtherInformation(otherInformation: data.other)
    }
}
