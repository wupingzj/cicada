//
//  PWUserService.swift
//  cicada
//
//  Created by Ping on 31/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import Foundation

let userServiceInstance = PWUserService()
class PWUserService {
    class var sharedInstance: PWUserService {
        return userServiceInstance
    }
    
    func isLoggedon() -> Bool {
        // TODO - to be implemented
        return true
    }
    
    func logon(#user: String, password: String) -> Bool {
        // TODO - to be implemented
        return true
    }
    
    func logoff() -> Bool {
        // TODO - to be implemented
        return true
    }
}