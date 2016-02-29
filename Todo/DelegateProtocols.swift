//
//  TodoTableDelegate.swift
//  Todo
//
//  Created by 杨洋 on 16/2/26.
//  Copyright © 2016年 Sheepy. All rights reserved.
//

import UIKit

protocol ViewModelType {
    typealias Model
    func bindModel(model: Model)
}

protocol ErrorHandler: class {
    func handleError(error: NSError)
}

protocol ItemUIDelegate: class {
    func showItemList(itemList: [Item])
    func addItem(item: Item)
    //func updateItemWithTitle(title: String, content:)
    func updateItem()
    func deleteItem()
    //func changeItemToStatus(status: ItemStatus)
}
