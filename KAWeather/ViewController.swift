//
//  ViewController.swift
//  KAWeather
//
//  Created by hjliu on 2015/8/4.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var originalData = [
        weatherData(cityId: "1668341", cityName: "臺北", webCamUrl: ""),
        weatherData(cityId: "1850147", cityName: "東京", webCamUrl: ""),
        weatherData(cityId: "2643743", cityName: "倫敦", webCamUrl: ""),
    ]
    
    var weatherModel:WeatherModel!
    var webCamModel:WebCamModel!
    
    var infoView = InfoView()
    var collectionView = CollectionView()
    var collectionViewConstraint:NSLayoutConstraint!
    
    //資料設定到畫廊
    var weatherGalleryDatas:[weatherData]!{
        didSet{
            
            if weatherGalleryDatas.count > 0{
                collectionView.datas = weatherGalleryDatas
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(collectionView)

        infoView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(infoView)
        
        var views = [
            "top":self.topLayoutGuide,
            "collectionView":collectionView,
            "infoView":infoView
            ] as [NSObject:AnyObject]

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[infoView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[top][collectionView][infoView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        
        collectionViewConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 235)
        self.view.addConstraint(collectionViewConstraint)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeGallery:",
            name: KAWeatherGallery,
            object: nil)
        
        webCamModel = WebCamModel(onComplete: setUrlImage)
        weatherModel = WeatherModel(onComplete: setInfoData)
        
        //預設modelData
        weatherModel.initWeatherDatas(originalData, onComplete: { datas in
            self.weatherGalleryDatas = datas
        })
    }
    
    func changeGallery(noti: NSNotification) {
        
        if let data = noti.object as? weatherData {
            
            infoView.setData(data.cityName, data: data.info!) //設定infoview data
            
            if data.webCamUrl != ""{
                //url 查詢圖片
                webCamModel.getImageByUrl(data.webCamUrl)
            }
            
            //loaction id查詢天氣狀態
            weatherModel.getWeatherById(data.cityID)
        }
    }
    
    func setUrlImage(url:String,image:UIImage?){
        
        //有圖片
        if let image = image{
            
            collectionViewConstraint.constant = (image.size.height / image.size.width) * self.collectionView.frame.width
            
            var tempDatas = weatherGalleryDatas
            
            //url取得該data
            var weatherData = tempDatas.filter({ $0.webCamUrl == url }).first
            
            //有data
            if let weatherData = weatherData{
                weatherData.webCamImage = image
                
                weatherGalleryDatas = tempDatas
            }
        }
    }
    
    func setInfoData(data:iofoData){
        
        var tempDatas = weatherGalleryDatas
        
        //id取得該data
        var tempWeatherData = tempDatas.filter({ $0.cityID == data.cityID }).first
        
        //有data
        if let tempWeatherData = tempWeatherData{
            tempWeatherData.info = data
            
            if tempWeatherData.webCamUrl == ""{
                tempWeatherData.webCamImage = weatherModel.getWeatherImage(data.status)
            }
            
            weatherGalleryDatas = tempDatas
        }
    }
}

