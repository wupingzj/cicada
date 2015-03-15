//
//  PWMessage.swift
//  cicada
//
//  Created by Ping on 14/03/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation
import CoreData

class PWMessage: PWAbstractEntity {
    @NSManaged
    var text: String
    
    // TODO
    // attachment
    // secure message etc
    
    // INIT data for creation. It's called only once in whole life-cycle.
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        // createdDate cannot be initialized in AbstractEntity
        self.createdDate = NSDate()
        self.modifiedDate = nil
    }
}