//
//  Item.swift
//  Todoey
//
//  Created by Amit Virani on 3/6/19.
//  Copyright © 2019 Amit Virani. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date?
    // backward relationship
    //many to one
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

