//
//  Model.swift
//  SimpleSwiftList
//
//  Created by Gareth Jones on 2/14/15.
//  Copyright (c) 2015 Gareth Jones. All rights reserved.
//

import UIKit
import CoreData

//make class available to obj-c : optional
@objc(Model)
class Model: NSManagedObject {
    
    //properties feeding the attributes in our entity must match the entity attributes
    @NSManaged var item: String
    @NSManaged var quantity: String
    @NSManaged var info: String
    
}
