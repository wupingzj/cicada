//
//  DataLoader.swift
//  cicada
//
//  Created by Ping on 8/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import Foundation

import CoreData

// MARK: PWCountryLoader
class PWCountryLoader {
    func getCountryList() -> [Country] {
        let (managedObjects, error) = DataDao.listEntities("Country", fault:false, sortByKey: "name", ascending: false, fetchBatchSize:20)
        
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
            println("contry[\(index)]: \(entity.name) \(entity.active)  imageUrl=\(entity.imageUrl) ")
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
        self.createCountry("Australia", active: true, useState: true, imageUrl: "/image/country/Australia.3.jpg")
        self.createCountry("China", active: true, useState: true, imageUrl: "/image/country/China.3.jpg")
        self.createCountry("United States", active: true, useState: true, imageUrl: "/image/country/USA.3.jpg")
        self.createCountry("United Kindom", active: true, useState: true, imageUrl: "/image/country/UK.3.jpg")
        self.createCountry("Thailand", active: false, useState: true, imageUrl: "/image/country/Thailand.3.jpg")
        self.createCountry("India", active: false, useState: true, imageUrl: "/image/country/India.3.jpg")
        self.createCountry("Singapore", active: true, useState: false, imageUrl: "/image/country/Singapore.3.jpg")
        self.createCountry("New Zealand", active: true, useState: false, imageUrl: "/image/country/NZ.3.jpg")
        self.createCountry("Germany", active: true, useState: true, imageUrl: "/image/country/Germany.3.jpg")
        self.createCountry("Russia", active: true, useState: true, imageUrl: "/image/country/Russia.3.jpg")
        self.createCountry("Holland", active: false, useState: false, imageUrl: "/image/country/Holland.3.jpg")
        self.createCountry("Fiji", active: true, useState: false, imageUrl: "/image/country/Fiji.3.jpg")
        
        
        var error: NSError? = DataService.sharedInstance.saveContext()
        if let err = error {
            println("**** Failed to save data context. \(err.userInfo)")
            return false
        } else {
            return true
        }
    }
    
    private func createCountry(name:String, active:Bool, useState: Bool, imageUrl: String) -> Country {
        let newCountry: Country = Country.createEntity()
        
        newCountry.name = name
        newCountry.active = active
        newCountry.useState = useState
        newCountry.imageUrl = imageUrl
        
        return newCountry
    }
}

// MARK: PWDestinationLoader
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
        
        let (managedObjects, error) = DataDao.listEntities("Destination", fault:false, sortByKey: "city", ascending: false, fetchBatchSize:20)
        
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
            println("destination[\(index)]: \(entity.town), \(entity.city) country:\(entity.country.name) ")
        }
    }
    
    // *** BE CAREFUL ****
    func deleteAllDestinations() {
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
        
        self.createDestination("Lindfield", city: "Sydney", state: "New South Wales", postCode: "2070", displayOrder: 0, countryName: "Australia", timeZoneName: "Australia/Sydney")
        self.createDestination("Burwood", city: "Melbourne", state: "Victoria", postCode: "3001", displayOrder: 0, countryName: "Australia", timeZoneName: "Australia/Melbourne")
        self.createDestination("Karori", city: "Wellington", state: nil, postCode: "2067", displayOrder: 0, countryName: "New Zealand", timeZoneName: "Pacific/Auckland")
        self.createDestination("Lower Hutt", city: "Wellington", state: nil, postCode: "2001", displayOrder: 0, countryName: "New Zealand", timeZoneName: "Pacific/Auckland")
        self.createDestination("Upper Hutt", city: "Wellington", state: nil, postCode: "2002", displayOrder: 0, countryName: "New Zealand", timeZoneName: "Pacific/Auckland")
        self.createDestination("Any", city: "Porirua", state: nil, postCode: "2002", displayOrder: 0, countryName: "New Zealand", timeZoneName: "Pacific/Auckland")


        
        var error: NSError? = DataService.sharedInstance.saveContext()
        if let err = error {
            println("**** Failed to save data context. \(err.userInfo)")
            return false
        } else {
            return true
        }
    }
    
    private func createDestination(town: String?, city: String, state: String?, postCode: String, displayOrder: Int16, countryName: String, timeZoneName: String) -> PWDestination? {
        if let country = getCountry(countryName) {
            let newDestination = PWDestination.createEntity()
            
            newDestination.town = town
            newDestination.city = city
            newDestination.state = state
            newDestination.postCode = postCode
            newDestination.displayOrder = displayOrder
            newDestination.country = country
            newDestination.timeZoneName = timeZoneName
            
            return newDestination
            
        }
        
        return nil
    }
}

// MARK: PWRequestLoader
class PWRequestLoader {
    func getRequestList() -> [PWRequest] {
        var dataDao: DataDao = DataDao()
        
        let (managedObjects, error) = DataDao.listEntities("Request", fault:false, sortByKey: "destination", ascending: false, fetchBatchSize:20)
        
        if (error != nil) {
            println("****** Failed to get all busines entities. Unresolved error \(error), \(error!.description)")
            
            return [PWRequest]()
        } else {
            println("There are totally \(managedObjects.count) request entities in store.")
            
            // cast to business entities
            let entities: [PWRequest] = managedObjects as [PWRequest]
            return entities
        }
    }
    
    func display(entities: [PWRequest]) {
        for (index, entity) in enumerate(entities) {
            println("request[\(index)]: \(entity.arrivalDate), \(entity.departureDate), \(entity.status), destination:\(entity.destination.toString()) ")
        }
    }
    
    func deleteAllRequests() {
        let businessEntities: [PWRequest] = getRequestList()
        display(businessEntities)
        
        let dataService: DataService = DataService.sharedInstance
        let ctx:NSManagedObjectContext = dataService.getContext()
        
        //ctx.deletedObjects(businessEntities)
        for (index, entity) in enumerate(businessEntities) {
            ctx.deleteObject(entity)
        }
        
        var error: NSError? = dataService.saveContext()
        if let err = error {
            println("******* Failed to save data context. \(err.userInfo)")
        }
    }

    // For each destination, create a test request
    func createRequests() -> Bool {
        
        let dataloader = PWDestinationLoader()
        let destinations: [PWDestination] = dataloader.getDestinationList()
        for (index, destination) in enumerate(destinations) {
            let request = PWRequest.createRequest(destination, arrivalDate: NSDate(), departureDate: NSDate())
        }
        
        var error: NSError? = DataService.sharedInstance.saveContext()
        if let err = error {
            println("**** Failed to save data context. \(err.userInfo)")
            return false
        } else {
            return true
        }
    }
}


// MARK: PWQuoteLoader
class PWQuoteLoader {
    func getQuotetList() -> [PWQuote] {
        var dataDao: DataDao = DataDao()
        
        let (managedObjects, error) = DataDao.listEntities("Quote", fault:false, sortByKey: "request", ascending: false, fetchBatchSize:20)
        
        if (error != nil) {
            println("****** Failed to get all quote entities. Unresolved error \(error), \(error!.description)")
            
            return [PWQuote]()
        } else {
            println("There are totally \(managedObjects.count) quote entities in store.")
            
            // cast to business entities
            let entities: [PWQuote] = managedObjects as [PWQuote]
            return entities
        }
    }
    
    func display(entities: [PWQuote]) {
        for (index, entity) in enumerate(entities) {
            println("quote[\(index)]: \(entity.uuid) createdDate=\(entity.createdDate) ")
        }
    }
    
    func deleteAllQuotes() {
        let quotes: [PWQuote] = getQuotetList()
        display(quotes)
        
        let dataService: DataService = DataService.sharedInstance
        let ctx:NSManagedObjectContext = dataService.getContext()
        
        //ctx.deletedObjects(businessEntities)
        for (index, entity) in enumerate(quotes) {
            ctx.deleteObject(entity)
        }
        
        var error: NSError? = dataService.saveContext()
        if let err = error {
            println("******* Failed to save data context. \(err.userInfo)")
        }
    }
    
    // For each request, create two test quotes
    func createQuotes() -> Bool {
        let dataloader = PWRequestLoader()
        let requests: [PWRequest] = dataloader.getRequestList()
        for (index, request) in enumerate(requests) {
            let quote = PWQuote.createQuote(request)
            println("**** quote uuid: \(quote.uuid)")
        }
        
        var error: NSError? = DataService.sharedInstance.saveContext()
        if let err = error {
            println("**** Failed to save data context. \(err.userInfo)")
            return false
        } else {
            return true
        }
    }
}



