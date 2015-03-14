//
//  PWMessage.swift
//  cicada
//
//  Created by Ping on 14/03/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation
import CoreData

class PWMessage: NSManagedObject {
    @NSManaged
    var text: String
    
    // TODO
    // attachment
    // secure message etc
}