//
//  CreateItemViewController.swift
//  Todo
//
//  Created by 杨洋 on 16/2/26.
//  Copyright © 2016年 Sheepy. All rights reserved.
//

import UIKit

enum EditerType {
    case Create
    case Edit
}

class ItemEditerController: UIViewController {
    
    var type = EditerType.Create
    
    var itemTitle = ""
    var itemContent = ""
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.text = itemTitle
        contentTextView.text = itemContent
    }

}
