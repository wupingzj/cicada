//
//  Country.swift
//  cicada
//
//  Created by Ping on 8/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

// Reference: http://stackoverflow.com/questions/24024549/dispatch-once-singleton-model-in-swift

import Foundation
import CoreData

let dataServiceInstance = DataService()
public class DataService {
    // Singleton
    class var sharedInstance : DataService {
        return dataServiceInstance
    }
    
    init() {
        println("Initializing the singleton DataServie.")
    }
    
    // #pragma mark - Core Data stack
    
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    // managed object context for frontend GUI work
    var ctx: NSManagedObjectContext {
        if _ctx == nil {
            let coordinator = self.sharedPSC
            _ctx = NSManagedObjectContext()
            _ctx!.persistentStoreCoordinator = coordinator
        }
        return _ctx!
    }
    private var _ctx: NSManagedObjectContext? = nil
    
    // managed object context for background communication
    var ctxForNetwork: NSManagedObjectContext {
        if _ctxForNetwork == nil {
            let coordinator = self.sharedPSC
            _ctxForNetwork = NSManagedObjectContext()
            _ctxForNetwork!.persistentStoreCoordinator = coordinator
        }
            
        return _ctxForNetwork!
    }
    private var _ctxForNetwork: NSManagedObjectContext? = nil
    
    
    // *** persistentStoreCoordinator ***
    // To Allow concurrent data access, the persistentStoreCoordinator should be singleton
    
    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    var sharedPSC: NSPersistentStoreCoordinator {
        if _persistentStoreCoordinator == nil {
            let storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("cicadaV1.1.sqlite")
            println(storeURL)
            
            
            var options:NSDictionary = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            
            
            var error: NSError? = nil
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            if _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: &error) == nil {
                /*
                Replace this implementation with code to handle the error appropriately.
                
                abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                Typical reasons for an error here include:
                * The persistent store is not accessible;
                * The schema for the persistent store is incompatible with current managed object model.
                Check the error message to determine what the actual problem was.
                
                
                If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
                
                If you encounter schema incompatibility errors during development, you can reduce their frequency by:
                * Simply deleting the existing store:
                NSFileManager.defaultManager().removeItemAtURL(storeURL, error: nil)
                
                * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
                [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true}
                
                Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
                
                */
                println("Unresolved error \(error), \(error!.description)")
                //println("Unresolved error \(error), \(error.?.userInfo)")
                //abort()
            } else {
                println("successfully added data store.")
            }
        }
            
        return _persistentStoreCoordinator!
    }
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil
    
    
    
    // *** object model ***
    // If the model doesn't already exist, it is created from the application's model.
    var managedObjectModel: NSManagedObjectModel {
        if _managedObjectModel == nil {
            //let modelURL = NSBundle.mainBundle().URLForResource("QiuTuiJianV0", withExtension: "momd")
            let modelURL = NSBundle.mainBundle().URLForResource("cicadaModel", withExtension: "momd")
            
            println("model location= \(modelURL)")
            
            _managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!)
        }
            
        return _managedObjectModel!
    }
    private var _managedObjectModel: NSManagedObjectModel? = nil
    
    // #pragma mark - Application's Documents directory
    // Returns the URL to the application's Documents directory.
    var applicationDocumentsDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }
    
    // Returns the URL to the application's Support directory.
    var applicationSupportDirectory: NSURL {
        var error: NSError? = nil;
        let appSupportURL = NSFileManager.defaultManager().URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &error)
        return appSupportURL!
    }
    
    // #pragma mark - Save core data context
    // Caller must check the returned NSError to make sure no failure with save
    func saveContext() -> NSError? {
        if !ctx.hasChanges {
            return nil
        }

        println("*** Core data managed context has unsaved changes *** ")

        var error: NSError? = nil
        if !ctx.save(&error) {
            println("Error occurred while saving data: \(error!), \(error!.userInfo) ")
            return error!
        } else {
            println("Saved data successfully.")
            return nil
        }
    }
    
    public func getContext() -> NSManagedObjectContext {
        return ctx
    }
}
