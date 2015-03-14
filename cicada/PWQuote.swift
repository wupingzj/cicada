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

class PWQuote: NSManagedObject {
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
}
