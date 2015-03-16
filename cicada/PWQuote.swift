//
//  PWQuote.swift
//  cicada
//
//  Created by Ping on 12/03/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation
import CoreData

public enum PWQuoteStatus: String {
    case NEW = "NEW"
    case PROCESSING = "PROCESSING"
    case ACCEPTED = "ACCEPTED"
    case IGNORED = "IGNORED"
}

class PWQuote: PWAbstractEntity {
    // This UUID is generated on and comes back from server side. Don't generate on client side.
    @NSManaged
    var uuid: String
    
    @NSManaged
    var request: PWRequest
    
    @NSManaged
    var status: String
    
    @NSManaged
    var messages: [PWMessage]
    
    // TODO
    // communications
    
    // INIT data for creation. It's called only once in whole life-cycle.
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.uuid = NSUUID().UUIDString
        
        // createdDate cannot be initialized in AbstractEntity
        self.createdDate = NSDate()
        self.modifiedDate = nil
        
        self.status = PWQuoteStatus.NEW.rawValue
    }
    
    // As swift doesn't support class variable yet, use class function instead for now
    class func getEntityName() -> String {
        return "Quote"
    }
    
    class func createEntity() -> PWQuote {
        let ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
        let ed: NSEntityDescription = NSEntityDescription.entityForName(getEntityName(), inManagedObjectContext: ctx)!
        return PWQuote(entity: ed, insertIntoManagedObjectContext: ctx)
    }
    
    class func getEntityDescription() -> NSEntityDescription {
        let ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
        return NSEntityDescription.entityForName(getEntityName(), inManagedObjectContext: ctx)!
    }
    
    class func createQuote(request: PWRequest) -> PWQuote {
        let newQuote: PWQuote = PWQuote.createEntity()
        newQuote.request = request
        return newQuote
    }
}
