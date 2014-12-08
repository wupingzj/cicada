//
//  DataLoader.swift
//  cicada
//
//  Created by Ping on 8/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import Foundation

import CoreData

class DataLoader {
    func getCountryList() -> [Country] {
        var dataDao: DataDao = DataDao()
        
        let (managedObjects, error) = dataDao.listEntities("Country", fault:false, sortByKey: "name", ascending: false, fetchBatchSize:20)
        
        if (error != nil) {
            println("****** Failed to get all busines entities. Unresolved error \(error), \(error!.description)")
            
            return [Country]()
        } else {
            println("There are totally \(managedObjects.count) business entities in store.")
            
            // cast to business entities
            let businessEntities: [Country] = managedObjects as [Country]
            return businessEntities
        }
    }
    
    func dispplay(entities: [NSManagedObject]) {
        for (index, entity) in enumerate(entities) {
            println("business entity[\(index)]: \(entity)")
        }
    }
    
    // *** BE CAREFUL ****
    func xdeleteAllEntities() {
        let businessEntities: [Country] = getCountryList()
        dispplay(businessEntities)
        
        let dataService: DataService = DataService.sharedInstance
        let ctx:NSManagedObjectContext = dataService.getContext()

        //ctx.deletedObjects(businessEntities)
        for (index, Country) in enumerate(businessEntities) {
            ctx.deleteObject(Country)
        }
        
        var error: NSError? = dataService.saveContext()
        if let err = error {
            println("******* Failed to save data context. \(err.userInfo)")
        }
    }
    
    func createEntity() -> Bool {
        self.createCountry("Australia", active: true)
        self.createCountry("Argentina", active: true)
        self.createCountry("China", active: true)
        self.createCountry("United States", active: true)
        self.createCountry("United Kindom", active: true)
        self.createCountry("Thailand", active: false)
        self.createCountry("India", active: false)
        self.createCountry("Singapore", active: true)
        self.createCountry("New Zealand", active: true)
        self.createCountry("Germany", active: true)
        self.createCountry("Italy", active: true)
        self.createCountry("Greece", active: true)
        self.createCountry("Spain", active: true)
        self.createCountry("Russia", active: true)
        self.createCountry("Holland", active: true)
        self.createCountry("Fiji", active: true)
        
        
        var error: NSError? = DataService.sharedInstance.saveContext()
        if let err = error {
            println("**** Failed to save data context. \(err.userInfo)")
            return false
        } else {
            return true
        }
    }
    
    private func createCountry(name:String, active:Bool) -> Country {
        let newCountry: Country = Country.createEntity()
        
        newCountry.name = name
        newCountry.active = active
        
        return newCountry
    }
}
