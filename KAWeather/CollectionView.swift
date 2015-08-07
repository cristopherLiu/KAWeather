//
//  CollectionViewController.swift
//  KAWeather
//
//  Created by hjliu on 2015/8/4.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

var KAWeatherGallery = "KAWeatherGallery"

class CollectionView: UIView ,UICollectionViewDelegate ,UICollectionViewDataSource{

    var datas:[weatherData]!{
        didSet{
            
            originalImageArray = reduce(datas, NSMutableArray()) { (array,data) in
                
                array.addObject(data.webCamImage)
                return array
            }
            
            originalTextArray = reduce(datas, NSMutableArray()) { (array,data) in
                
                array.addObject(data.cityName)
                return array
            }
        }
    }
    
    private var originalImageArray:NSArray!{
        didSet{
            var tempArray =  NSMutableArray(array: originalImageArray as! [UIImage], copyItems: true)
            tempArray.addObject(originalImageArray[0])
            tempArray.insertObject(originalImageArray.lastObject!, atIndex: 0)
            workingImageArray = tempArray
        }
    }
    
    private var workingImageArray = NSMutableArray(){
        didSet{
            self.collection.reloadData()
            
            //移動至[first item]
            self.collection.scrollToItemAtIndexPath(currentIndexInWorkingArray
                , atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
            
            sendNotification(currentIndexInWorkingArray)
        }
    }
    
    private var originalTextArray:NSArray!{
        didSet{
            enablePage = true
            
            var tempArray =  NSMutableArray(array: originalTextArray as! [String], copyItems: true)
            tempArray.addObject(originalTextArray[0])
            tempArray.insertObject(originalTextArray.lastObject!, atIndex: 0)
            workingTextArray = tempArray
        }
    }
    
    private var workingTextArray = NSMutableArray()
    
    //是否換頁功能
    private var enablePage:Bool = false{
        didSet{
            self.setNeedsUpdateConstraints()
        }
    }
    
    private var collection:UICollectionView!
    private var leftButton = UIButton()
    private var rightButton = UIButton()
    
    var currentIndexInWorkingArray = NSIndexPath(forItem: 1, inSection: 0){
        didSet{
//            println("當前index:\(currentIndexInWorkingArray.item)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var layout = CollectionLayout()
        collection = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collection.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collection.backgroundColor = UIColor.whiteColor()
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.pagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(collection)
        
        leftButton.setBackgroundImage(UIImage(named: "icon_arrow_left"), forState: UIControlState.Normal)
        leftButton.addTarget(self, action: "toLeft", forControlEvents: UIControlEvents.TouchUpInside)
        leftButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(leftButton)
        
        rightButton.setBackgroundImage(UIImage(named: "icon_arrow_right"), forState: UIControlState.Normal)
        rightButton.addTarget(self, action: "toRight", forControlEvents: UIControlEvents.TouchUpInside)
        rightButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(rightButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var constraints1:[AnyObject]?
    var constraints2:[AnyObject]?
    var constraints3:[AnyObject]?
    var constraints4:[AnyObject]?
    var constraints5:[AnyObject]?
    var constraints6:[AnyObject]?
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if let constraints1 = constraints1{
            self.removeConstraints(constraints1)
        }
        
        if let constraints2 = constraints2{
            self.removeConstraints(constraints2)
        }
        
        if let constraints3 = constraints3{
            self.removeConstraints(constraints3)
        }
        
        if let constraints4 = constraints4{
            self.removeConstraints(constraints4)
        }
        
        if let constraints5 = constraints5{
            self.removeConstraints(constraints5)
        }
        
        if let constraints6 = constraints6{
            self.removeConstraints(constraints6)
        }
        
        var views = [
            "super":self,
            "collection" : collection,
            "leftButton":leftButton,
            "rightButton":rightButton,
        ]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collection]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collection]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        
        if enablePage == true{
            constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[leftButton(24)]", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
            self.addConstraints(constraints1!)
            
            constraints2 = NSLayoutConstraint.constraintsWithVisualFormat("H:[rightButton(24)]-16-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
            self.addConstraints(constraints2!)
            
            constraints3 = NSLayoutConstraint.constraintsWithVisualFormat("V:[rightButton(24)]", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
            self.addConstraints(constraints3!)
            
            constraints4 = NSLayoutConstraint.constraintsWithVisualFormat("V:[rightButton(24)]", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
            self.addConstraints(constraints4!)
            
            constraints5 = NSLayoutConstraint.constraintsWithVisualFormat("H:[super]-(<=0)-[leftButton]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
            self.addConstraints(constraints5!)
            
            constraints6 = NSLayoutConstraint.constraintsWithVisualFormat("H:[super]-(<=0)-[rightButton]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
            self.addConstraints(constraints6!)
        }
    }


    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workingImageArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.image = workingImageArray[indexPath.item] as! UIImage
        cell.title =  workingTextArray[indexPath.item] as! String
        
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
//        println("didSelectItemAtIndexPath:\(indexPath.item)")
//    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if let currentIndexPath = getCurrentIndexPath(){
            
            if currentIndexPath.item == workingImageArray.count - 1{
                
                //使用者 "右"捲動 從[last item]->[造假的first item] 完成後
                //新定位偏移，移動到左端真正的first item
                self.collection.scrollToItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
                
                sendNotification(NSIndexPath(forItem: 1, inSection: 0))
                
            }else if currentIndexPath.item == 0{
                
                //使用者 "左"捲動 從[first item]->[造假的last item] 完成後
                //新定位偏移，移動到右端真正的last item
                self.collection.scrollToItemAtIndexPath(NSIndexPath(forItem: self.workingImageArray.count - 2, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
                
                sendNotification(NSIndexPath(forItem: workingImageArray.count - 2, inSection: 0))
                
            }else{
                sendNotification(currentIndexPath)
            }
        }
    }
    
    //按下左移按鈕
    func toLeft(){
        
        if let currentIndexPath = getCurrentIndexPath(){
            
            //如果當前item為[first item]
            if currentIndexPath.item == 1{
                
                //跳到[造假的first item]
                self.collection.scrollToItemAtIndexPath(NSIndexPath(forItem: workingImageArray.count - 1, inSection: 0)
                    , atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
                
                //左切換到[last item]
                self.collection.scrollToItemAtIndexPath(NSIndexPath(forItem: workingImageArray.count - 2, inSection: 0)
                    , atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
                
                sendNotification(NSIndexPath(forItem: workingImageArray.count - 2, inSection: 0))
            }else{
                //左切換到下一個item
                self.collection.scrollToItemAtIndexPath(currentIndexPath - 1
                    , atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
                
                sendNotification(currentIndexPath - 1)
            }
        }
    }
    
    //按下右移按鈕
    func toRight(){
        
        if let currentIndexPath = getCurrentIndexPath(){
            
            //如果當前item為[last item]
            if currentIndexPath.item == workingImageArray.count - 2{
                
                //移到[造假的last item]
                self.collection.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)
                    , atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
                //右切換到[first item]
                self.collection.scrollToItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0)
                    , atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
                
                sendNotification(NSIndexPath(forItem: 1, inSection: 0))
            }
            else{
                //右切換到下一個item
                self.collection.scrollToItemAtIndexPath(currentIndexPath + 1
                    , atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
                
                sendNotification(currentIndexPath + 1)
            }
        }
    }
    
    func sendNotification(index:NSIndexPath){
        
        currentIndexInWorkingArray = index
        var data = datas[(index - 1).item]
        
        NSNotificationCenter.defaultCenter().postNotificationName(KAWeatherGallery, object: data)
    }
    
    func getCurrentIndexPath()->NSIndexPath?{
        var initialPinchPoint = CGPointMake(self.collection.center.x + self.collection.contentOffset.x,
            self.collection.center.y + self.collection.contentOffset.y)
        return collection.indexPathForItemAtPoint(initialPinchPoint)
    }
}


func +(lhs: NSIndexPath, rhs: Int) -> NSIndexPath{
    return NSIndexPath(forItem: lhs.item + rhs, inSection:lhs.section)
}

func -(lhs: NSIndexPath, rhs: Int) -> NSIndexPath{
    return NSIndexPath(forItem: lhs.item - rhs, inSection:lhs.section)
}

