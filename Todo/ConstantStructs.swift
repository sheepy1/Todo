//
//  Constant.swift
//  Todo
//
//  Created by 杨洋 on 16/2/24.
//  Copyright © 2016年 Sheepy. All rights reserved.
//

import UIKit

struct API {
    private static let BaseURL = "http://interview.yunzao.cn/api/100/item/"
    
    static let List = BaseURL + "list"
    static let Create = BaseURL + "create"
    static let Update = BaseURL + "update"
    static let Delete = BaseURL + "delete"
    static let Finish = BaseURL + "finish"
    static let Revert = BaseURL + "revert"
}

struct RequestInfo {
    static let Token = "bbecc6c06e6d21e095996820fc6ea6aa"
}

struct ResponseInfo {
    static let ErrorCodeMapper = [
        -1: "invalid request",
        1: "param not set",
        2: "invalid token",
        3: "wrong type of param",
        4: "wrong name of param",
        5: "wrong password",
        6: "wrong param",
        7: "saving error",
        8: "record doesn't exist",
        9: "record exists",
        10: "request not allowed",
        11: "invalid verify code"
    ]
}

struct Key {
    static let Token = "token"
    
    static let Code = "code"
    static let Data = "data"
    
    // Item property
    static let Id = "id"
    static let UserId = "user_id"
    static let Title = "title"
    static let Content = "content"
    static let Status = "status"
    static let CreateTime = "create_time"
    static let UpdateTime = "update_time"
}

struct CellId {
    static let Item = "Item"
} 

struct SegueId {
    static let CreateItem = "Create Item"
    static let EditItem = "Edit Item"
    static let ShowStatusMenu = "Show Status Menu"
    static let SelectItemStatus = "Select Item Status"
}

struct ActionTitle {
    static let Delete = "删除"
    
    static let Finish = "标记完成"
    static let Revert = "撤销完成"
}

struct AlertMessage {
    static let Cancel = "好的"
    static let HTTPSuggestion = "操作无法生效，请检查您的网络设置"
    static let DataSuggestion = "远程数据变更，请先下拉刷新"
}

struct QueueName {
    static let RealmQueue = "Realm Queue"
}

struct UpdateTime {
    static let Today = "今天"
    static let Yesterday = "昨天"
    static let TheDayBeforeYesterday = "前天"
}

struct DateFormat {
    static let ComparableDate = "yyMMdd"
    static let Date = "MM/dd"
    static let Time = "HH:mm"
}