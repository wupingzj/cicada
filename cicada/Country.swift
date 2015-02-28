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
    
    // As swift doesn't support class variable yet, use class function instead for now
    class func getEntityName() -> String {
        return "Country"
    }
    
    class func createEntity() -> Country {
        let ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
        let ed: NSEntityDescription = NSEntityDescription.entityForName(getEntityName(), inManagedObjectContext: ctx)!
        return Country(entity: ed, insertIntoManagedObjectContext: ctx)
    }
    
    class func getCountryEntityDescription() -> NSEntityDescription {
        let ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
        return NSEntityDescription.entityForName(getEntityName(), inManagedObjectContext: ctx)!
    }
    
    class func createCountry(#name: String, active: Bool, useState: Bool) -> Country {
        let newCountry: Country = Country.createEntity()
        
        newCountry.name = name
        newCountry.active = active
        newCountry.useState = useState
        
        return newCountry
    }
}
