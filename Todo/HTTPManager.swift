//
//  HTTPTask.swift
//  Todo
//
//  Created by 杨洋 on 16/2/24.
//  Copyright © 2016年 Sheepy. All rights reserved.
//

import UIKit
import SwiftyJSON

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

typealias CompletionHandler = (result: JSON) -> ()

private let instance = HTTPManager()

class HTTPManager {
    
    weak var errorHandler: ErrorHandler!
    
    private init() {}
    
    static var sharedManager: HTTPManager {
        return instance
    }
    
    func taskWithURLString(urlString: String, method: HTTPMethod = .POST, params: [String: AnyObject]?, completionHandler: CompletionHandler) -> NSURLSessionDataTask? {
        guard let url = NSURL(string: urlString) else {
            print("URL error: \(urlString)")
            return nil
        }
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        switch method {
        case .POST, .PUT:
            if let params = params {
                request.HTTPBody = queryStringWithParams(params).dataUsingEncoding(NSUTF8StringEncoding)
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
        case .GET, .DELETE:
            break
        }
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if let error = error {
                self.errorHandler.handleHTTPError(error)
            }
            
            if let data = data {
                let json = JSON(data: data)
                let code = json[Key.Code].intValue
                switch code {
                case 0:
                    let result = json[Key.Data]
                    // NSURLSession 会开启次新的后台队列处理网络任务，UI 操作必须调度回主队列
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(result: result)
                    }
                    
                default:
                    // 打印错误信息
                    if let errorInfo = ResponseInfo.ErrorCodeMapper[code] {
                        print(errorInfo)
                        self.errorHandler.handleDataError()
                    } else {
                        print("Unknown error.")
                    }
                }
            }
        }
        // 启动
        task.resume()
        
        return task
    }
    
    // 拼接查询字符串
    func queryStringWithParams(params: [String: AnyObject]) -> String {
        var array = [String]()
        
        for (key, value) in params {
            let str = key + "=" + value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            array.append(str)
        }
        
        return array.joinWithSeparator("&")
    }
}
