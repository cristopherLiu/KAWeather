//
//  UrlConnection.swift
//  KAWeather
//
//  Created by hjliu on 2015/8/7.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

class WebService:NSObject{
    
    class func QueryWeather(location:String ,onComplete: [NSDictionary] -> Void ,onError: ConnectionStatus -> Void){
        
        var url = "http://api.openweathermap.org/data/2.5/group" //WS網址
        
        //組成QueryString
        var queryString = Utility.FromDictionaryToQueryString(["id":location])
        
        var request = NSMutableURLRequest()
        request.URL = NSURL(string: "\(url)?\(queryString)&units=metric") //Url
        request.HTTPMethod = "Get"
        request.timeoutInterval = 20
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        
        //連接WS
        UrlConnection.sendAsynchronousRequest(__FUNCTION__,request: request, queue: NSOperationQueue(),
            onComplete:onComplete,
            onError:onError
        )
    }
}


class UrlConnection: NSObject {
    
    //網路非同步處理，取得Json數據
    class func sendAsynchronousRequest(functionName:String ,request: NSURLRequest, queue: NSOperationQueue, onComplete: [NSDictionary] -> Void, onError:(ConnectionStatus->Void)){
        
        //非同步取得數據
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!)
            -> Void in
            
            //返回主執行緒
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                //連線發生錯誤
                if(error != nil){
                    
                    println("\(functionName) 連線發生錯誤...1")
                    onError(ConnectionStatus.ConnectionRequestError)
                    return
                }
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    if httpResponse.statusCode == 500{
                        println("\(functionName) 連線發生錯誤...2")
                        onError(ConnectionStatus.ConnectionRequestError)
                        return
                    }
                    
                    if httpResponse.statusCode == 404{
                        println("\(functionName) 連線發生錯誤...3")
                        onError(ConnectionStatus.ConnectionRequestError)
                        return
                    }
                }
                
                var arrayResult = data.parseJson()
                
                //有查詢資料
                if let arrayResult = arrayResult {
                    
                    onComplete(arrayResult)
                }
            })
        })
    }
}

//連線狀態
enum ConnectionStatus: Printable {
    
    case OK,JsonResultError,ConnectionRequestError,NotReachable
    
    var description: String {
        switch self {
        case .OK:
            return "OK"
        case .JsonResultError:
            return "伺服器資料錯誤"
        case .ConnectionRequestError:
            return "伺服器連線發生錯誤"
        case .NotReachable:
            return "未連接至網路"
        }
    }
}
