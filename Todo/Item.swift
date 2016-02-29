//
//  Item.swift
//  Todo
//
//  Created by 杨洋 on 16/2/25.
//  Copyright © 2016年 Sheepy. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    dynamic var id = 0
    dynamic var userId = 0
    
    dynamic var title = ""
    dynamic var content = ""
    dynamic var status = 0
    
    dynamic var createTime: NSTimeInterval = 0
    dynamic var updateTime: NSTimeInterval = 0
    
    override static func primaryKey() -> String {
        return Key.Id
    }
    
    override static func indexedProperties() -> [String] {
        return [Key.Id]
    }
    
}
