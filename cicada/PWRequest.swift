//
//  PWRequest.swift
//  cicada
//
//  Created by Ping on 12/03/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation
import CoreData

class PWRequest: NSManagedObject {
    @NSManaged
    var uuid: String
    
    @NSManaged
    var destination: PWDestination
    
    @NSManaged
    var arrivalDate: NSDate
    
    @NSManaged
    var departureDate: NSDate
    
    // INIT data for creation. It's called only once in whole life-cycle.
    override func awakeFromInsert() {
        super.awakeFromInsert()

        // createdDate cannot be initialized in AbstractEntity
        self.uuid = NSUUID().UUIDString
    }
    
}
