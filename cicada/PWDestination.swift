//
//  PWDestination.swift
//  cicada
//
//  Created by Ping on 14/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import Foundation
import CoreData

public class PWDestination: NSManagedObject {
    @NSManaged
    var displayOrder: Int16
    
    @NSManaged
    var town: String?
    
    @NSManaged
    var city: String
    
    @NSManaged
    var state: String?
    
    @NSManaged
    var postCode: String
    
    @NSManaged
    var country: Country
    
    class func createEntity() -> PWDestination {
        let ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
        let ed: NSEntityDescription = NSEntityDescription.entityForName("Destination", inManagedObjectContext: ctx)!
        let newEntity = PWDestination(entity: ed, insertIntoManagedObjectContext: ctx)
        
        return newEntity
    }
}