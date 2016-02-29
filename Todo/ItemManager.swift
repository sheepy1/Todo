//
//  HTTPManager.swift
//  Todo
//
//  Created by 杨洋 on 16/2/26.
//  Copyright © 2016年 Sheepy. All rights reserved.
//

import Foundation
import RealmSwift


private let instance = ItemManager()

class ItemManager {
    var httpManager: HTTPManager
    
    // 单例
    static var sharedManager: ItemManager {
        return instance
    }
    // 不对外提供初始化方法，只能在本文件范围使用
    private init() {
        httpManager = HTTPManager.sharedManager
    }
    
    lazy var realm = try! Realm()
    
    weak var delegate: ItemUIDelegate!
    weak var errorHandler: ErrorHandler! {
        didSet {
            httpManager.errorHandler = errorHandler
        }
    }
    
    // MARK: - 查询事项
    func loadItemListWithSatusOption(statusOption: ItemStatusOption) {
        switch statusOption {
        case .All:
            loadAllItemList()
        case .Finished:
            loadItemListWithPredicate(.Finished)
        case .Unfinished:
            loadItemListWithPredicate(.Unfinished)
        }
    }
    
    func loadAllItemList() {
        let storedItemList = realm.objects(Item.self)
        
        if storedItemList.count > 0 {
            // 根据更新时间排序
            let sortedItemList = storedItemList.sort {
                $0.0.updateTime > $0.1.updateTime
            }
            
            delegate.showItemList(sortedItemList)
            
        } else {
            // 联网获取数据
            let params = [Key.Token: RequestInfo.Token]
            httpManager.taskWithURLString(API.List, params: params) { result in
                // 不能直接用 map，map 是个范型方法，传入闭包的返回类型和参数类型一致
                var itemList = [Item]()
                result.arrayValue.forEach {
                    let item = Item()
                    item.id = $0[Key.Id].intValue
                    item.userId = $0[Key.UserId].intValue
                    item.title = $0[Key.Title].stringValue
                    item.content = $0[Key.Content].stringValue
                    item.status = $0[Key.Status].intValue
                    item.createTime = $0[Key.CreateTime].doubleValue
                    item.updateTime = $0[Key.UpdateTime].doubleValue
                    itemList.append(item)
                }
                
                let sortedItemList = itemList.sort {
                    $0.0.updateTime > $0.1.updateTime
                }
                self.delegate.showItemList(sortedItemList)
                
                // 存入数据库
                try! self.realm.write {
                    self.realm.add(sortedItemList, update: true)
                }
            }
            
        }
    }
    
    private func loadItemListWithPredicate(predicate: ItemStatusPredicate) {
        let itemList = realm.objects(Item.self).filter(predicate.rawValue).sort {
            $0.0.updateTime > $0.1.updateTime
        }
        delegate.showItemList(itemList)
    }
    
    // MARK: - 新增事项
    func createItemWithTitle(title: String, content: String) {
        let params = [
            Key.Token: RequestInfo.Token,
            Key.Title: title,
            Key.Content: content
        ]
        
        httpManager.taskWithURLString(API.Create, params: params) { result in
            let timestamp = NSDate().timeIntervalSince1970
            let item = Item()
            item.title = title
            item.content = content
            item.createTime = timestamp
            item.updateTime = timestamp
            item.id = result[Key.Id].intValue
            
            self.delegate.addItem(item)
            
            try! self.realm.write {
                self.realm.add(item)
            }
        }
    }
    
    // MARK: - 删除事项
    func deleteItem(item: Item) {
        let params = [
            Key.Token: RequestInfo.Token,
            Key.Id: "\(item.id)"
        ]
        httpManager.taskWithURLString(API.Delete, params: params) { result in
            self.delegate.deleteItem()

            try! self.realm.write {
                self.realm.delete(item)
            }
        }
    }
    
    // MARK: - 更新事项标题和内容
    func updateItem(item: Item, withTitle title: String, content: String) {
        let params = [
            Key.Token: RequestInfo.Token,
            Key.Id: "\(item.id)",
            Key.Title: title,
            Key.Content: content
        ]
        httpManager.taskWithURLString(API.Update, params: params) { _ in
            //self.delegate.updateItem()
            
            let updateTime = NSDate().timeIntervalSince1970
            try! self.realm.write {
                item.title = title
                item.content = content
                item.updateTime = updateTime
            }
            
            self.delegate.updateItem()
        }
    }
    
    // MARK: - 更新事项状态
    func updateItem(item: Item, with status: ItemStatus) {
        let params = [
            Key.Token: RequestInfo.Token,
            Key.Id: "\(item.id)"
        ]
        httpManager.taskWithURLString(status.actionURL, params: params) { _ in
            let changedStatus = status.changeStatus()
            let updateTime = NSDate().timeIntervalSince1970
            try! self.realm.write {
                item.status = changedStatus.rawValue
                item.updateTime = updateTime
            }
            
            self.delegate.updateItem()
        }
    }
}