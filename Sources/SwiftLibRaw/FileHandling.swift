//
//  FileHandling.swift
//  SwiftLibRaw
//
//  Created by Thorsten Claus on 24.12.20.
//

import Foundation
import libraw
import OSLog

public class FileHandling {
    
    func openDataStream(stream : Any) -> LibRaw_errors
    {
        return LIBRAW_SUCCESS
    }
    
    /// Creates a new object  that will be filled from libraw Data
    public static func initLibRawData() -> UnsafeMutablePointer<libraw_data_t> {
       return  libraw_init(0)
    }
    
    /// Tests if a file can be opened. Returns a zero if file cpould be open.
    /// This only reads the files metadata without actually unpack the image itself. To do so, use the Unpack function
    /// Returns an error otherwise. The libraw Data object becomes invalid in case of an error.
    /// - Parameters:
    ///   - fileUrl: Full path to supported RAW file
    ///   - rawdata: Pointer to raw structure
    /// - Returns: 0 - Success or a LibRaw Error code
    public static func openFile(fileUrl : URL, rawdata: UnsafeMutablePointer<libraw_data_t>) -> LibRaw_errors {
        let result = libraw_open_file(rawdata, fileUrl.path)
        
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
    

    
    /// Unpack image metadata after a file was opened
    public static func metaData(rawdata: UnsafeMutablePointer<libraw_data_t>) -> MetaDataInformation {
        return MetaDataInformation(rawdata)
    }
    
    /// Unpacked Images must be released at end of processing
    static func recycle(rawdata: UnsafeMutablePointer<libraw_data_t>) {
        libraw_recycle(rawdata);
    }
    
    /// Closes any open data object. You dont need to call this from extern
    static func closeData(rawdata: UnsafeMutablePointer<libraw_data_t>) {
        libraw_close(rawdata)
    }
}
