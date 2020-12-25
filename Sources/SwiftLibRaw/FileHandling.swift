//
//  FileHandling.swift
//  SwiftLibRaw
//
//  Created by Thorsten Claus on 24.12.20.
//

import Foundation
import libraw
import OSLog

class FileHandling {
    
    func openDataStream(stream : Any) -> LibRaw_errors
    {
        // int LibRaw::open_datastream(LibRaw_abstract_datastream *stream)
        return LIBRAW_SUCCESS
    }
    
    /// Tests if a file can be opened. Returns a zero if file cpould be open.
    /// This only reads the files metadata without actually unpack the image itself. To do so, use the Unpack function
    /// Returns an error otherwise. The libraw Data object becomes invalid in case of an error.
    /// - Parameters:
    ///   - filePath: Full path to supported RAW file
    ///   - rawdata: Pointer to raw structure
    /// - Returns: 0 - Success or a LibRaw Error code
    static func openFile(filePath : String, rawdata: UnsafeMutablePointer<libraw_data_t>) -> LibRaw_errors {
        let result = libraw_open_file(rawdata, filePath)
        
        if (result != LIBRAW_SUCCESS.rawValue) {
            if #available(OSX 11.0, *) {
               let defaultLog = Logger()
               let errorMessage = String(cString: libraw_strerror(result))
                defaultLog.log("LibRaw error: \(errorMessage)")
            }
            libraw_close(rawdata);
        }
        // let data = UnsafeMutableRawPointer( Unmanaged<libraw_data_t.self>.fromOpaque(rawdata!).takeUnretainedValue()
        return LibRaw_errors.init(result)
    }
    
    /// Unpacks the RAW files of the image, calculates the black level (not for all formats). The results are placed in imgdata.image.
    static func unpackFile(rawdata: UnsafeMutablePointer<libraw_data_t>) -> LibRaw_errors {
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
    
    /// Closes any open data object.
    static func closeData(rawdata: UnsafeMutablePointer<libraw_data_t>) {
        libraw_close(rawdata)
    }
}
