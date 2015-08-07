//
//  webCamModel.swift
//  KAWeather
//
//  Created by hjliu on 2015/8/7.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

class WebCamModel: NSObject {
    
    var timer:NSTimer? //計時器
    
    var webComUrl:String = ""
    var onQueryComplete:((String, UIImage?)->())!
    
    init(onComplete:(String, UIImage?)->()) {
        super.init()
        
        onQueryComplete = onComplete
        
        //開啟計時器
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "queryUrlImage", userInfo: nil, repeats: true)
    }
    
    deinit{
        timer?.invalidate() //關閉timer
    }
    
    func getImageByUrl(url:String){
        webComUrl = url
    }
    
    internal func queryUrlImage(){
        
        if webComUrl == ""{
            return
        }
        
        var nsUrl = NSURL(string: self.webComUrl)
        
        //可查詢
        if let nsUrl = nsUrl{
            
            var data = NSData(contentsOfURL: nsUrl)
            
            if let data = data{
                
                self.onQueryComplete(self.webComUrl,UIImage(data: data))
                return
            }
        }
    }
}
