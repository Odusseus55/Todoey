//
//  Category.swift
//  Todoey
//
//  Created by Matyas Mihalka on 23/10/2018.
//  Copyright © 2018 Matyas Mihalka. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
