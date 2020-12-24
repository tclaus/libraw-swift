
import Darwin
import libraw

public class AuxiliaryFunctions {
    
    // Returns string representation of LibRaw version in MAJOR.MINOR.PATCH-Status format (i.e. 0.6.0-Alpha2 or 0.6.1-Release).
    static func libVersion() -> String {
        // LibRaw::version()
        //return LibRaw::version()
        let versionPtr = libraw_version()!
        return String.init(cString: versionPtr)
    }
    
    // Returns integer representation of LibRaw version. During LibRaw development, the version number is always increase .
    static func libVersionNumber() -> Int {
        return Int(libraw_versionNumber())
    }
    
    // Returns list of supported cameras
    static func cameraList() -> [String] {
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
}
extension String {
    

}
