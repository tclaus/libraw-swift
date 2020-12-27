
import Darwin
import libraw

public class AuxiliaryFunctions {
    
    // Returns string representation of LibRaw version in MAJOR.MINOR.PATCH-Status format (i.e. 0.6.0-Alpha2 or 0.6.1-Release).
    public static func libVersion() -> String {
        let versionPtr = libraw_version()!
        return String(cString: versionPtr)
    }
    
    // Returns integer representation of LibRaw version. During LibRaw development, the version number is always increase .
    public static func libVersionNumber() -> Int {
        return Int(libraw_versionNumber())
    }
    
    // Returns list of supported cameras
   public  static func cameraList() -> [String] {
        let ptr = libraw_cameraList()!
        let length = Int(libraw_cameraCount())
        var pointee = ptr.pointee!
        var cameras : [String] = []
        for _ in 0...length {
            let cameraModel = String(cString:pointee)
            cameras.append(cameraModel)
            pointee = pointee.advanced(by: strlen(cameraModel) + 1 )
        }
        return cameras
    }
    
    // This call returns count of non-fatal data errors (out of range, etc) occured in unpack() stage.
    static func errorCount() -> Int {
        return 0 // Int(libraw_err error_count())
    }
}

