//
//  RCategory.swift
//  Todoey-IOS13
//
//  Created by Daniil Demidovich on 27.03.22.
//

import RealmSwift

class RCategory: Object {
    @Persisted var name: String = ""
    
    @Persisted var todoItems: List<RTodoItem>
}
