//
//  PWStringUtils.swift
//  cicada
//
//  Created by Ping on 19/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import Foundation

class PWStringUtils {
    class func concatString(aString: String, append: String?, newLine: Bool) -> String {
        if append == nil {
            return aString
        } else if newLine {
            return aString + "\n" + append!
        } else {
            return aString + ", " + append!
        }
    }
}