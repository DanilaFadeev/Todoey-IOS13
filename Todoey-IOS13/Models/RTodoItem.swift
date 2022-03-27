//
//  RTodoItem.swift
//  Todoey-IOS13
//
//  Created by Daniil Demidovich on 27.03.22.
//

import Foundation
import RealmSwift

class RTodoItem: Object {
    @Persisted var title: String = ""
    @Persisted var isDone: Bool = false
    @Persisted var createdAt: Date = Date()
    
    @Persisted(originProperty: "todoItems") var parentCategory: LinkingObjects<RCategory>
}
