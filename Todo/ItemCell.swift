//
//  ItemCell.swift
//  Todo
//
//  Created by 杨洋 on 16/2/25.
//  Copyright © 2016年 Sheepy. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemCell: UITableViewCell, ViewModelType {
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var itemContentLabel: UILabel!
    
    func bindModel(model: Item) {
        itemTitleLabel.text = model.title
        itemContentLabel.text = model.content
        
        let timestamp = model.updateTime
        updateTimeLabel.text = timeStringWithTimestamp(timestamp)
        
        let statusRaw = model.status
        let status = ItemStatus(rawValue: statusRaw)
        backgroundColor = status?.backgroundColor
    }
    
    // 处理时间戳
    func timeStringWithTimestamp(timestamp: Double) -> String {
        var dateString = ""
        let now = NSDate()
        let date = NSDate(timeIntervalSince1970: timestamp)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        let nowInt = Int(dateFormatter.stringFromDate(now))
        let dateInt = Int(dateFormatter.stringFromDate(date))
        switch nowInt! - dateInt! {
        case 0:
            dateString = UpdateTime.Today
        case 1:
            dateString = UpdateTime.Yesterday
        case 2:
            dateString = UpdateTime.TheDayBeforeYesterday
        default:
            dateFormatter.dateFormat = "yy/MM/dd"
            dateString = dateFormatter.stringFromDate(date)
        }
        dateFormatter.dateFormat = "HH:mm"
        return dateString + " \(dateFormatter.stringFromDate(date))"
    }
    
}
