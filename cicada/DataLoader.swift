//
//  DataLoader.swift
//  cicada
//
//  Created by Ping on 8/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import Foundation

import CoreData

class PWCountryLoader {
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
    
    func display(entities: [Country]) {
        for (index, entity) in enumerate(entities) {
            println("contry[\(index)]: \(entity.name) \(entity.active) ")
        }
    }
    
    func display(entities: [NSManagedObject]) {
        for (index, entity) in enumerate(entities) {
            println("business entity[\(index)]: \(entity)")
        }
    }
    
    // *** BE CAREFUL ****
    func deleteAllCountries() {
        let businessEntities: [Country] = getCountryList()
        display(businessEntities)
        
        let dataService: DataService = DataService.sharedInstance
        let ctx:NSManagedObjectContext = dataService.getContext()

        //ctx.deletedObjects(businessEntities)
        for (index, country) in enumerate(businessEntities) {
            ctx.deleteObject(country)
        }
        
        var error: NSError? = dataService.saveContext()
        if let err = error {
            println("******* Failed to save data context. \(err.userInfo)")
        }
    }
    
    func createCountries() -> Bool {
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

// ********************
class PWDestinationLoader {
    func getCountry(countryName: String) -> Country? {
        var dataDao: DataDao = DataDao()
        let ctx = DataService.sharedInstance.getContext()
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Country", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "name == %@", countryName)

        var error: NSError? = nil
        let countries:[Country] = ctx.executeFetchRequest(fetchRequest, error: &error) as [Country]

        if (error != nil) {
            println("****** Failed to execute Fetch Request to get Countrys. Unresolved error \(error), \(error!.userInfo)")
            
            return nil
        } else {
            if (countries.count == 0) {
                println("No country is found matching \(countryName)")
                return nil
            } else if (countries.count == 1) {
                return countries[0]
            } else {
                println("More than one countries are found matching \(countryName). Return the first one")
                return countries[0]
            }
        }
    }
    
    func getDestinationList() -> [PWDestination] {
        var dataDao: DataDao = DataDao()
        
        let (managedObjects, error) = dataDao.listEntities("Destination", fault:false, sortByKey: "city", ascending: false, fetchBatchSize:20)
        
        if (error != nil) {
            println("****** Failed to get all busines entities. Unresolved error \(error), \(error!.description)")
            
            return [PWDestination]()
        } else {
            println("There are totally \(managedObjects.count) business entities in store.")
            
            // cast to business entities
            let entities: [PWDestination] = managedObjects as [PWDestination]
            return entities
        }
    }
    
    func display(entities: [PWDestination]) {
        for (index, entity) in enumerate(entities) {
            println("destination[\(index)]: \(entity.city) country:\(entity.country.name) ")
        }
    }
    
    // *** BE CAREFUL ****
    func XXXdeleteAllCountries() {
        let businessEntities: [PWDestination] = getDestinationList()
        display(businessEntities)
        
        let dataService: DataService = DataService.sharedInstance
        let ctx:NSManagedObjectContext = dataService.getContext()
        
        //ctx.deletedObjects(businessEntities)
        for (index, country) in enumerate(businessEntities) {
            ctx.deleteObject(country)
        }
        
        var error: NSError? = dataService.saveContext()
        if let err = error {
            println("******* Failed to save data context. \(err.userInfo)")
        }
    }
    
    func createDestinations() -> Bool {
        
        self.createDestination("Killara", city: "Sydney", state: "New South Wales", postCode: "2071", displayOrder: 0, countryName: "Australia")
        self.createDestination("Karori", city: "Wellington", state: nil, postCode: "2067", displayOrder: 0, countryName: "New Zealand")
        
        var error: NSError? = DataService.sharedInstance.saveContext()
        if let err = error {
            println("**** Failed to save data context. \(err.userInfo)")
            return false
        } else {
            return true
        }
    }
    
    private func createDestination(town: String?, city: String, state: String?, postCode: String, displayOrder: Int16, countryName: String) -> PWDestination? {
        if let country = getCountry(countryName) {
            let newDestination = PWDestination.createEntity()
            
            newDestination.town = town
            newDestination.city = city
            newDestination.state = state
            newDestination.postCode = postCode
            newDestination.displayOrder = displayOrder
            newDestination.country = country
            
            return newDestination
            
        }
        
        return nil
    }
}




