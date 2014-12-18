//
//  Country.swift
//  cicada
//
//  Created by Ping on 8/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import Foundation
import CoreData

public class Country: NSManagedObject {
    @NSManaged
    var name: String
    
    @NSManaged
    var active: Bool

    @NSManaged
    var useState: Bool

    @NSManaged
    //var destinations: [PWDestination]
    var destinations: NSSet
    
    class func createEntity() -> Country {
        let ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
        let ed: NSEntityDescription = NSEntityDescription.entityForName("Country", inManagedObjectContext: ctx)!
        let newEntity = Country(entity: ed, insertIntoManagedObjectContext: ctx)
        
        return newEntity
    }
}
