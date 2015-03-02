//
//  DataDao.swift
//  cicada
//
//  Created by Ping on 8/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import Foundation
import CoreData

// Important note on error-handling:
//  Caller must check return NSError before use returned managed object array to make sure the retrieval was successful.
class DataDao {
    class func listEntities(entityName:String) -> (managedObjects: [NSManagedObject], error: NSError?) {
        return listEntities(entityName, fault:false, sortByKey: nil, ascending: false, fetchBatchSize:20)
    }
    
    class func listEntities(entityName:String, fault:Bool?, sortByKey:String?, ascending:Bool?, fetchBatchSize:Int?) -> (managedObjects: [NSManagedObject], error: NSError?) {
        
        println("**** Will retrieve all \(entityName) entities ****")
        
        let dataService: DataService = DataService.sharedInstance
        let ctx: NSManagedObjectContext = dataService.ctx
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        //let fetchRequest = NSFetchRequest()
        //let MobileED: NSEntityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: ctx)
        //fetchRequest.entity = MobileED
        
        
        // Set faulting behavior
        if (fault != nil) {
            fetchRequest.returnsObjectsAsFaults = false
        } else {
            // defaul to disable faulting
            // otherwise, you would see data = {fault} if you don't access the fields
            fetchRequest.returnsObjectsAsFaults = false
        }
        
        //fetchRequest.includesPropertyValues = true
        
        // Set the batch size
        if (fetchBatchSize != nil) {
            fetchRequest.fetchBatchSize = fetchBatchSize!
        }
        
        // Set the sort key
        if (sortByKey != nil && ascending != nil) {
            let sortDescriptor = NSSortDescriptor(key: sortByKey!, ascending: ascending!)
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        var error: NSError? = nil
        // To make the class downcast possible, the Mobile entity must be mapped to QiuTuiJianTests.Mobile in the data model
        // I.E., the model class in Test Target
        //var Mobiles: Mobile[] = ctx.executeFetchRequest(fetchRequest, error: &error) as Mobile[]
        var managedObjects: [NSManagedObject] = ctx.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]
        
        if let actualError = error {
            println("An Error Occurred: \(actualError)")
        }
        
        if (error != nil) {
            // log error
            println("Failed to get all \(entityName)s. Unresolved error \(error), \(error!.description)")
        }
        
        return (managedObjects, error)
    }
    
    class func findCountryBy(countryName: String) -> Country? {
        let fetchRequest = NSFetchRequest(entityName: Country.getEntityName())
        fetchRequest.predicate = NSPredicate(format: "name == %@", countryName)

//        fetchRequest.returnsObjectsAsFaults = false
//        fetchRequest.includesPropertyValues = true
//        fetchRequest.fetchBatchSize = 0
        
        var error: NSError? = nil
        let ctx = DataService.sharedInstance.getContext()
        var countries: [Country] = ctx.executeFetchRequest(fetchRequest, error: &error) as [Country]
        
        if let err = error {
            println("****** Failed to execute Fetch Request to get Countrys. Unresolved error \(error), \(error!.userInfo)")
            return nil
        }
        
        if countries.count == 0 {
            println("Error: No country is found matching name \(countryName)")
            return nil
        } else if countries.count == 1 {
            return countries[0]
        } else {
            println("Error: More than one countries are found matching \(countryName).")
            return nil
        }
    }
}