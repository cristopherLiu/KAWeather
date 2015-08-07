//
//  c.swift
//  KAWeather
//
//  Created by hjliu on 2015/8/4.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

class GalleryView : UIView ,UIScrollViewDelegate {
    
    private var scrollView = UIScrollView() //滾動view
    private var pageControl = UIPageControl()
    private var leftButton = UIButton()
    private var rightButton = UIButton()
    
    private var views:[pageView] = []{
        didSet{
            if views.count > 1{
                enablePage = true
            }else{
                enablePage = false
            }
        }
    }
    
    //是否換頁功能
    private var enablePage:Bool = false{
        didSet{
            self.updateConstraintsIfNeeded()
        }
    }
    
    init(){
        super.init(frame: CGRect.zeroRect)
        
        scrollView.pagingEnabled = true //允許以頁為單位換頁
        scrollView.bounces = false //不允許反彈
        scrollView.showsHorizontalScrollIndicator = false //關閉水平滑動條
        scrollView.delegate = self
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(scrollView)
        
        //page Control
        pageControl.pageIndicatorTintColor = UIColor.ColorRGB(0x434A54, alpha: 0.4)
        pageControl.currentPageIndicatorTintColor = UIColor.ColorRGB(0x434A54, alpha: 1)
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(pageControl)
        
        leftButton.setBackgroundImage(UIImage(named: "icon_arrow_left"), forState: UIControlState.Normal)
        leftButton.addTarget(self, action: "toLeft", forControlEvents: UIControlEvents.TouchUpInside)
        leftButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(leftButton)
        
        rightButton.setBackgroundImage(UIImage(named: "icon_arrow_right"), forState: UIControlState.Normal)
        rightButton.addTarget(self, action: "toRight", forControlEvents: UIControlEvents.TouchUpInside)
        rightButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(rightButton)
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
            "scrollView":scrollView,
            "pageControl": pageControl,
            "leftButton":leftButton,
            "rightButton":rightButton,
            ] as [NSObject:AnyObject]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[super]-(<=0)-[pageControl]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[pageControl(100)]", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pageControl(8)]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addPage(view:pageView){
        views.append(view) //加入list
    }
    
    func clearAllPage(){
        
        for view in views {
            view.removeFromSuperview()
        }
        views = []
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for (index,view) in enumerate(views) {
            var vw:CGFloat = scrollView.frame.width
            var vh:CGFloat = scrollView.frame.height
            var vx:CGFloat = scrollView.frame.width * CGFloat(index)
            var vy:CGFloat = 0
            view.frame = CGRectMake(vx, vy, vw, vh)
            scrollView.addSubview(view)
        }
        
        //有異動 要調整contentSize
        scrollView.contentSize = CGSizeMake(self.frame.width * CGFloat(views.count), self.frame.height)
        pageControl.numberOfPages = views.count
    }
    
    //手勢滑動，修改index
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        var currentIndex:Int = Int(scrollView.contentOffset.x / self.frame.width) //第幾頁
        pageControl.currentPage = currentIndex
    }
    
    func toLeft(){
        
        //沒有view則不執行動畫
        if views.count == 0{
            return
        }
        
        var nextPage = pageControl.currentPage - 1 //上一頁index
        
        if nextPage == -1{
            return
        }else{
            UIView.animateWithDuration(0.3,
                delay: 0,
                //動畫時允許使用者繼續動作  //時間曲線函數，慢到快
                options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseOut,
                animations: { () -> Void in
                    
                    //換到下一頁
                    self.scrollView.scrollRectToVisible(CGRectMake(self.frame.width * CGFloat(nextPage), 0, self.frame.width, self.frame.height), animated: false)
                    
                }) { (finished) -> Void in
                    if finished{
                        self.pageControl.currentPage = nextPage
                    }
            }
        }
    }
    
    func toRight(){
        //沒有view則不執行動畫
        if views.count == 0{
            return
        }
        
        var nextPage = pageControl.currentPage + 1  //下一頁index
        
        if nextPage == views.count{
            return
        }else{
            UIView.animateWithDuration(0.3,
                delay: 0,
                //動畫時允許使用者繼續動作  //時間曲線函數，慢到快
                options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseOut,
                animations: { () -> Void in
                    
                    //換到下一頁
                    self.scrollView.scrollRectToVisible(CGRectMake(self.frame.width * CGFloat(nextPage), 0, self.frame.width, self.frame.height), animated: false)
                    
                }) { (finished) -> Void in
                    if finished{
                        self.pageControl.currentPage = nextPage
                    }
            }
        }
    }
}


class pageView:UIView{
    
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
    
    init(){
        super.init(frame: CGRect.zeroRect)
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}
