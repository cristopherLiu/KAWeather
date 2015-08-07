//
//  CollectionViewCell.swift
//  KAWeather
//
//  Created by hjliu on 2015/8/4.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private var imageView = UIImageView()
    private var titleText = UILabel()
    
    var image:UIImage!{
        didSet{
            imageView.image = image
        }
    }
    
    var title:String!{
        didSet{
            titleText.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(imageView)
        
        titleText.font = UIFont.systemFontOfSize(20)
        titleText.textColor = UIColor.ColorRGB(0xFFFFFF, alpha: 1)
        titleText.textAlignment = NSTextAlignment.Left
        titleText.numberOfLines = 1
        
        titleText.layer.shadowColor = UIColor.blackColor().CGColor
        titleText.layer.shadowRadius = 3
        titleText.layer.shadowOffset = CGSize(width: 0, height: 1)
        titleText.layer.shadowOpacity = 0.9
        
        titleText.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.addSubview(titleText)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        var views = [
            "imageView" : imageView,
            "titleText" : titleText,
            ] as [NSObject:AnyObject]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        
        //橫
        imageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[titleText]", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        imageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleText]-16-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
    }
}
