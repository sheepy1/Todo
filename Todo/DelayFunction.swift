//
//  DelayFunction.swift
//  Todo
//
//  Created by 杨洋 on 16/2/29.
//  Copyright © 2016年 Sheepy. All rights reserved.
//

import Foundation

func delay(seconds seconds: Double, completion:()->()) {
    let invokeTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(invokeTime, dispatch_get_main_queue()) {
        completion()
    }
}