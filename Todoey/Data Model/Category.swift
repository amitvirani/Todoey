//
//  Category.swift
//  Todoey
//
//  Created by Amit Virani on 3/6/19.
//  Copyright © 2019 Amit Virani. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc  dynamic var categoryName : String = ""
    @objc dynamic var categoryCellColor : String = ""
    
    // forward relationship one to many
    let items = List<Item>()
    
}
