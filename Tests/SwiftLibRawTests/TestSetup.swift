//
//  TestSetup.swift
//  SwiftLibRawTests
//
//  Created by Thorsten Claus on 08.01.21.
//

import Foundation

// During Test its not the main bundle
var testfilePath : URL! {
    get {
       let bundle = Bundle.init(for: TestFileHandling.self)
        return bundle.url(forResource: "Moon", withExtension: "RAF")!
    }
}
