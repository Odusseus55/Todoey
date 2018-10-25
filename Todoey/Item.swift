//
//  Item.swift
//  Todoey
//
//  Created by Matyas Mihalka on 23/10/2018.
//  Copyright © 2018 Matyas Mihalka. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    
//    Definition of the back relationship
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    @objc dynamic var dateCreated : Date?
    
    
    
}
