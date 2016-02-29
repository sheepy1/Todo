//
//  TodoTableViewController.swift
//  Todo
//
//  Created by 杨洋 on 16/2/25.
//  Copyright © 2016年 Sheepy. All rights reserved.
//

import UIKit
import SwiftyJSON


class ItemListController: UITableViewController {
    
    var selectedIndexPath: NSIndexPath!
    
    var itemList = [Item]()
    
    lazy var manager: ItemManager = {
        let manager = ItemManager.sharedManager
        manager.delegate = self
        manager.errorHandler = self
        return manager
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 去除顶部空白
        tableView.tableHeaderView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 0, height: 0.1)))
        
        manager.loadAllItemList()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 解决快速右滑返回时选中状态不取消的问题
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
    
    // MARK: - Config segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let id = segue.identifier else { return }
        
        switch id {
        case SegueId.EditItem:
            // 将标题和内容传递给编辑页面
            let editerController = segue.destinationViewController as! ItemEditerController
            selectedIndexPath = tableView.indexPathForSelectedRow
            let selectedRow = selectedIndexPath.row
            let item = itemList[selectedRow]
            // TextField 此时尚未初始化，不能调用。
            //editerController.titleTextField?.text = item[Key.Title].stringValue
            //editerController.contentTextView?.text = item[Key.Content].stringValue
            editerController.itemTitle = item.title
            editerController.itemContent = item.content
            editerController.type = .Edit
            
        case SegueId.ShowStatusMenu:
            segue.destinationViewController.popoverPresentationController?.delegate = self
        default:
            break
        }
    }
    
    @IBAction func unwindForSegue(segue: UIStoryboardSegue) {
        if let editerController = segue.sourceViewController as? ItemEditerController {
            let title = editerController.titleTextField.text ?? ""
            let content = editerController.contentTextView.text ?? ""
            
            switch editerController.type {
            case .Create:
                // 创建了一条新事项
                manager.createItemWithTitle(title, content: content)
                
            case .Edit:
                // 修改了一条事项
                let item = itemList[selectedIndexPath.row]
                manager.updateItem(item, withTitle: title, content: content)
            }
        }
        
        if let itemStatusController = segue.sourceViewController as? ItemStatusController {
            let selectedOption = itemStatusController.selectedOption
            // 根据选中的状态更新数据
            navigationItem.leftBarButtonItem?.title = selectedOption.rawValue
            manager.loadItemListWithSatusOption(selectedOption)
        }
    }
}

// MARK: - Table view data source
extension ItemListController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellId.Item, forIndexPath: indexPath) as! ItemCell
        cell.bindModel(itemList[indexPath.row])
        return cell
    }
}

// MARK: - Table view delegate
extension ItemListController {

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 自定义左滑出现的按钮
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        selectedIndexPath = indexPath
        let item = itemList[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .Default, title: ActionTitle.Delete) { _, _ in
            self.manager.deleteItem(item)
        }
        
        // 根据当前状态判断接下来进行的操作, 若状态初始化失败则只返回删除事件
        guard let status = ItemStatus(rawValue: item.status) else {
            return [deleteAction]
        }
    
        let statusAction = UITableViewRowAction(style: .Normal, title: status.actionTitle) { _, _ in
            // 远程及本地数据库状态更新
            self.manager.updateItem(item, with: status)
            
            tableView.editing = false
        }

        return [deleteAction, statusAction]
    }
    
}

// MARK: - Item UI delegate
extension ItemListController: ItemUIDelegate {
    func showItemList(itemList: [Item]) {
        self.itemList = itemList
        tableView.reloadData()
    }
    
    func addItem(item: Item) {
        itemList.insert(item, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
    }

    func updateItem() {
        tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Right)
    }
    
    func deleteItem() {
        self.itemList.removeAtIndex(selectedIndexPath.row)
        tableView.deleteRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Fade)
    }
}

// MARK: - Error handler
extension ItemListController: ErrorHandler {
    func handleError(error: NSError) {
        let alertController = UIAlertController(title: error.localizedDescription, message: Alert.Suggestion, preferredStyle: .Alert)
        presentViewController(alertController, animated: true) {
            self.delay(seconds: 1) {
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func delay(seconds seconds: Double, completion:()->()) {
        let invokeTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(invokeTime, dispatch_get_main_queue()) {
            completion()
        }
    }
}

// MARK: - Popover delegate
extension ItemListController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
