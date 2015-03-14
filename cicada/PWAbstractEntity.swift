//
//  PWAbstractEntity.swift
//  cicada
//
//  Created by Ping on 14/03/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation

import CoreData

public class PWAbstractEntity: NSManagedObject {
    @NSManaged
    public var createdDate: NSDate
    
    @NSManaged
    public var modifiedDate: NSDate
}
