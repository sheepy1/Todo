//
//  ItemStatus.swift
//  Todo
//
//  Created by 杨洋 on 16/2/25.
//  Copyright © 2016年 Sheepy. All rights reserved.
//

import UIKit

enum ItemStatus: Int {
    case Default = 0
    case Finished = 1
    
    var actionTitle: String {
        switch self {
        case .Default:
            return ActionTitle.Finish
        case .Finished:
            return ActionTitle.Revert
        }
    }
    
    var actionURL: String {
        switch self {
        case .Default:
            return API.Finish
        case .Finished:
            return API.Revert
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .Default:
            return UIColor.whiteColor()
        case .Finished:
            return UIColor.groupTableViewBackgroundColor()
        }
    }
    
    func changeStatus() -> ItemStatus {
        switch self {
        case .Default:
            return .Finished
        case .Finished:
            return .Default
        }
    }
}

enum ItemStatusOption: String {
    case All = "全部"
    case Finished = "已完成"
    case Unfinished = "未完成"
}

enum ItemStatusPredicate: String {
    case Finished = "status == 1"
    case Unfinished = "status == 0"
}