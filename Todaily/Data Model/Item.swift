//
//  Item.swift
//  Todaily
//
//  Created by Tayyab Ejaz on 25/09/2018.
//  Copyright © 2018 Tayyab Ejaz. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var createdDate: Date?
    
    //Defing a Parent Class
    //-- Inverse Relationship (Child to Parent) --
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
