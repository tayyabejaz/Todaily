//
//  Category.swift
//  Todaily
//
//  Created by Tayyab Ejaz on 25/09/2018.
//  Copyright © 2018 Tayyab Ejaz. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    //Defining Realtionship
    // -- Forward Relationship(Parent to Child) --
    let items = List<Item>()
}
