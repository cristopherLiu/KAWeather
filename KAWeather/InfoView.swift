//
//  InfoView.swift
//  KAWeather
//
//  Created by hjliu on 2015/8/5.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

class InfoView: UIView {

    private var leftView = UIView()
    private var rightView = UIView()
    
    private var iconImageView = UIImageView() //icon
    private var line = UIView()//分隔線
    private var temperatureLabel = UILabel() //溫度
    private var locationLabel = UILabel() //地點
    private var statusLabel = UILabel() //天氣狀態
    private var humidityLabel = UILabel() //濕度
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(leftView)
        rightView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(rightView)
        
        line.backgroundColor = UIColor.ColorRGB(0x434A54, alpha: 1)
        line.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(line)
        
        iconImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        leftView.addSubview(iconImageView)
        
        temperatureLabel.font = UIFont.systemFontOfSize(32)
        temperatureLabel.textColor = UIColor.ColorRGB(0x434A54, alpha: 1)
        temperatureLabel.textAlignment = NSTextAlignment.Left
        temperatureLabel.numberOfLines = 1
        temperatureLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        rightView.addSubview(temperatureLabel)
        
        locationLabel.font = UIFont.systemFontOfSize(14)
        locationLabel.textColor = UIColor.ColorRGB(0x434A54, alpha: 1)
        locationLabel.textAlignment = NSTextAlignment.Left
        locationLabel.numberOfLines = 1
        locationLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        rightView.addSubview(locationLabel)
        
        statusLabel.font = UIFont.systemFontOfSize(14)
        statusLabel.textColor = UIColor.ColorRGB(0x434A54, alpha: 1)
        statusLabel.textAlignment = NSTextAlignment.Left
        statusLabel.numberOfLines = 1
        statusLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        rightView.addSubview(statusLabel)
        
        humidityLabel.font = UIFont.systemFontOfSize(14)
        humidityLabel.textColor = UIColor.ColorRGB(0x434A54, alpha: 1)
        humidityLabel.textAlignment = NSTextAlignment.Left
        humidityLabel.numberOfLines = 1
        humidityLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        rightView.addSubview(humidityLabel)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func updateConstraints() {
        super.updateConstraints()
        
        var views = [
            "super":self,
            "rightView":rightView,
            "leftView":leftView,
            "line":line,
            
            "iconImageView":iconImageView,
            
            "temperatureLabel":temperatureLabel,
            "locationLabel":locationLabel,
            "statusLabel":statusLabel,
            "humidityLabel":humidityLabel,
        ]
        
        //底
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[leftView][line(0.75)][rightView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-32-[leftView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-32-[rightView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-32-[line(80)]", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[super]-(<=0)-[line]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views))
        //左
        leftView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[iconImageView(64)]", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        leftView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[iconImageView(64)]", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        leftView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[leftView]-(<=0)-[iconImageView]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views))
        //右
        rightView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-32-[temperatureLabel]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        rightView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-32-[locationLabel]-8-[statusLabel]-(>=16)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        rightView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-32-[humidityLabel]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        
        rightView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[temperatureLabel][locationLabel][humidityLabel]", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        rightView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[temperatureLabel][statusLabel][humidityLabel]", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
    }
    
    func setData(location:String, data:iofoData){
        
        iconImageView.image = data.statusImage
        
        temperatureLabel.text = data.temperature //溫度
        locationLabel.text = location //地點
        statusLabel.text = data.status //狀態
        humidityLabel.text = data.humidity //濕度
    }
}

