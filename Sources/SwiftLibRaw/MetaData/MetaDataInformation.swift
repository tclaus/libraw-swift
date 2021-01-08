//
//  MetaDataInformation.swift
//  SwiftLibRaw
//
//  Created by Thorsten Claus on 07.01.21.
//

import Foundation
import libraw

public struct MetaDataInformation {
    public let lensinfo : Lense
    public let sizes : ImageSizes
    public let parameters : ImageParameters
    public let otherInformation : ImageOtherInformation
    
    init(_ rawdata: UnsafeMutablePointer<libraw_data_t>) {
        
        let data = rawdata.pointee
        
        lensinfo = Lense(lensInfo: data.lens)
        sizes = ImageSizes(sizes: data.sizes)
        parameters = ImageParameters(parameters: data.idata)
        otherInformation = ImageOtherInformation(otherInformation: data.other)
    }
}
