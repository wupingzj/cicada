//
//  PWRequest.swift
//  cicada
//
//  Created by Ping on 12/03/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation
import CoreData

public enum PWRequestStatus: String {
    case NEW = "NEW"
    case PROCESSING = "PROCESSING"
    case DELETED = "DELETED"
}

class PWRequest: PWAbstractEntity {
    @NSManaged
    var uuid: String
    
    @NSManaged
    var destination: PWDestination
    
    @NSManaged
    var arrivalDate: NSDate
    
    @NSManaged
    var departureDate: NSDate

    @NSManaged
    var status: String
    
    
    // INIT data for creation. It's called only once in whole life-cycle.
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.uuid = NSUUID().UUIDString

        // createdDate cannot be initialized in AbstractEntity
        self.createdDate = NSDate()
        self.modifiedDate = nil
        self.status = PWRequestStatus.NEW.rawValue
    }
    
    // As swift doesn't support class variable yet, use class function instead for now
    class func getEntityName() -> String {
        return "Request"
    }
    
    class func createEntity() -> PWRequest {
        let ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
        let ed: NSEntityDescription = NSEntityDescription.entityForName(getEntityName(), inManagedObjectContext: ctx)!
        return PWRequest(entity: ed, insertIntoManagedObjectContext: ctx)
    }
    
    class func getRequestEntityDescription() -> NSEntityDescription {
        let ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
        return NSEntityDescription.entityForName(getEntityName(), inManagedObjectContext: ctx)!
    }
    
    class func createRequest(destination: PWDestination, arrivalDate: NSDate, departureDate: NSDate) -> PWRequest {
        let newRequest: PWRequest = PWRequest.createEntity()
        
        newRequest.destination = destination
        newRequest.arrivalDate = arrivalDate
        newRequest.departureDate = departureDate
        
        return newRequest
    }
    
    func toString() -> String {
        return "\(self.destination.toDisplayString()), \(self.arrivalDate) - \(self.departureDate)";
    }
}
