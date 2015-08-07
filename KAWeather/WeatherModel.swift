//
//  WeatherModel.swift
//  KAWeather
//
//  Created by hjliu on 2015/8/5.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
   
    /// web API 查詢天氣狀態
    
    private var onQueryComplete:([iofoData]->())? //完成事件
    private var onQueryError: (String->())? //error事件
    
    private func queryLocationWeather(loaction:String,onComplete:([iofoData]->())?,onError:(String->())?){
        
        onQueryComplete = onComplete
        onQueryError = onError
        
        //webservice取得天氣
        WebService.QueryWeather(loaction,
            onComplete: onCompleteHandler,
            onError: onErrorHandler)
    }
    
    //完成事件
    private func onCompleteHandler(jsonResultList:[NSDictionary]) -> Void{
        
        println(jsonResultList)
        if jsonResultList.count > 0{
            
            var list = jsonResultList[0].objectForKey("list") as! [NSDictionary]
            
            
            var data = list.map({ iofoData().setData($0) })
            onQueryComplete?(data)
            return
        }
        onQueryError?("")
    }
    
    //webservice error發生
    private func onErrorHandler(error:ConnectionStatus) -> Void{
        onQueryError?(error.description)
    }
    
    
    var timer:NSTimer? //計時器
    
    var loactionId:String = ""
    var queryWeatherInfoComplete:((iofoData)->())!
    
    init(onComplete:((iofoData)->())) {
        super.init()
        
        queryWeatherInfoComplete = onComplete
        
        //開啟計時器
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "queryWeatherInfo", userInfo: nil, repeats: true)
    }
    
    deinit{
        timer?.invalidate() //關閉timer
    }
    
    func getWeatherById(LocationId:String){
        loactionId = LocationId
    }
    
    internal func queryWeatherInfo(){
        
        if loactionId == ""{
            return
        }
        
        queryLocationWeather(loactionId,
            onComplete: { infoDatas in
                
                let tempData = infoDatas.first
                
                if let data = tempData{
                    self.queryWeatherInfoComplete?(data)
                }
            },
            onError: { errorMsg in println(errorMsg) })
    }
    
    //init時 取得全部天氣資料
    func initWeatherDatas(originalData:[weatherData],onComplete:[weatherData]->()){
        
        var tempData = originalData
        
        //city ids
        var cityIDs = reduce(originalData, NSMutableArray()) { (ary, data) in
            ary.addObject(data.cityID)
            return ary
            } as NSObject as! [String]
        
        queryLocationWeather(",".join(cityIDs),
            onComplete: { infoDatas in
                
                for infoData in infoDatas{
                    
                    //查詢天氣狀態
                    var wData = tempData.filter({ $0.cityID == infoData.cityID }).first
                    
                    if let wData = wData{
                        wData.info = infoData
                        
                        if wData.webCamImage == nil{
                            wData.webCamImage = self.getWeatherImage(infoData.status)
                        }
                    }
                }
                
                onComplete(tempData)
            },
            onError: { errorMsg in println(errorMsg) })
    }
    
    func getWeatherImage(status:String)->UIImage{
        
        switch status{
        case "晴":
            return UIImage(named: "晴") ?? UIImage.imageWithColor(UIColor.lightGrayColor())
        case "晴時多雲":
            return UIImage(named: "晴時多雲") ?? UIImage.imageWithColor(UIColor.lightGrayColor())
        case "多雲":
            return UIImage(named: "多雲") ?? UIImage.imageWithColor(UIColor.lightGrayColor())
        case "多雲時陰":
            return UIImage(named: "多雲時陰") ?? UIImage.imageWithColor(UIColor.lightGrayColor())
        case "陣雨":
            return UIImage(named: "陣雨") ?? UIImage.imageWithColor(UIColor.lightGrayColor())
        case "雨":
            return UIImage(named: "雨") ?? UIImage.imageWithColor(UIColor.lightGrayColor())
        case "雷陣雨":
            return UIImage(named: "雷陣雨") ?? UIImage.imageWithColor(UIColor.lightGrayColor())
        default:
            return UIImage.imageWithColor(UIColor.lightGrayColor())
        }
    }
}


 /// 資料結構


class weatherData:Equatable{
    
    var cityID:String!
    var cityName:String!
    var webCamUrl:String!
    var webCamImage:UIImage!
    var info:iofoData?
    
    init(cityId:String,cityName:String,webCamUrl:String){
        self.cityID = cityId
        self.cityName = cityName
        self.webCamUrl = webCamUrl
    }
}

func ==(lhs: weatherData, rhs: weatherData) -> Bool{
    return lhs.cityID == lhs.cityID
}

class iofoData{
    
    var cityID:String = ""
    var temperature:String = "" //溫度
    var status:String = "" //天氣狀態
    var humidity:String = "" //濕度
    var statusImage:UIImage! //狀態圖
    
    func setData(dic:NSDictionary)->iofoData{
        var weatherArry = dic.objectForKey("weather") as? NSArray
        var mainDic = dic.objectForKey("main") as? NSDictionary
        
        cityID = String(dic.objectForKey("id") as? Int ?? 0) //id
        
        if let mainDic = mainDic{
            temperature = String(format:"%.1f度", (mainDic.objectForKey("temp") as? Double ?? 0)) //溫度
            humidity = String(format:"濕度 %.0f", mainDic.objectForKey("humidity") as? Double ?? 0) + "%" //濕度
        }
        
        if let weatherArry = weatherArry{
            
            var icon = weatherArry[0].objectForKey("icon") as? String ?? ""
            statusImage = UIImage(named: "icon_\(icon)") //狀態圖
            status = iconGetStatus(icon) //天氣狀態
        }
        return self
    }
    
    func iconGetStatus(icon:String)->String{
        
        switch icon{
        case "01d","01n":
            return "晴"
        case "02d","02n":
            return "晴時多雲"
        case "03d","03n":
            return "多雲"
        case "04d","04n":
            return "多雲時陰"
        case "09d","09n":
            return "陣雨"
        case "10d","10n":
            return "雨"
        case "11d","11n":
            return "雷陣雨"
        default:
            return ""
        }
    }
}



