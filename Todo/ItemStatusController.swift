//
//  ItemStatusTableViewController.swift
//  Todo
//
//  Created by 杨洋 on 16/2/27.
//  Copyright © 2016年 Sheepy. All rights reserved.
//

import UIKit

class ItemStatusController: UITableViewController {
    var selectedOption = ItemStatusOption.All
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 记录选中的状态
        if let text = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text, option = ItemStatusOption(rawValue: text) {
            selectedOption = option
        }
        performSegueWithIdentifier(SegueId.SelectItemStatus, sender: nil)
    }
    
}
