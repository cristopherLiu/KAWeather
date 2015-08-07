//
//  Extension.swift
//  KAWeather
//
//  Created by hjliu on 2015/8/4.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

extension UIColor{
    /**
    傳入16進位，轉換成顏色
    
    :param: rgbValue 16進位RGB
    :param: alpha    透明度
    
    :returns: ios可使用的color
    */
    class func ColorRGB(rgbValue: UInt,alpha:Double) -> UIColor{
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

extension UIView{
    
    func setShadow()->UIView{
        var layer = self.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.9
        
        return self
    }
}

extension UIImage{
    /**
    製作純色image
    
    :param: color 顏色
    
    :returns: 製作完成的image
    */
    class func imageWithColor(color:UIColor?) -> UIImage! {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()
        
        if let color = color {
            
            color.setFill()
        }
        else {
            
            UIColor.whiteColor().setFill()
        }
        
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension NSDictionary{
    /**
    字典檔轉換成json字串
    
    :returns: 轉換後的json字串
    */
    func toJson()->String!{
        return Utility.toJsonString(self)
    }
}

extension NSData{
    
    func parseJson()->[NSDictionary]?{
        
        var result:AnyObject? = NSJSONSerialization.JSONObjectWithData(self, options:NSJSONReadingOptions.MutableContainers, error: nil)
        
        if let result:AnyObject = result{
            
            //格式為副數dic(Array)
            if result is NSArray{
                return result as? [NSDictionary]
            }
                //格式為單數dic
            else if result is NSDictionary{
                return  [result as! NSDictionary]
            }
        }
        return nil
    }
}

extension String {
    
    //Url特殊字元處理
    var escaped: String {
        return CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,self,"[].",":/?&=;+!@#$()',*",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) as String
    }
    
    func parseJson()->[NSDictionary]?{
        
        let nsdata = (self as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        if let nsdata = nsdata{
            
            var result:AnyObject? = NSJSONSerialization.JSONObjectWithData(nsdata, options:NSJSONReadingOptions.MutableContainers, error: nil)
            
            if let result:AnyObject = result{
                
                //格式為副數dic(Array)
                if result is NSArray{
                    return result as? [NSDictionary]
                }
                    //格式為單數dic
                else if result is NSDictionary{
                    return  [result as! NSDictionary]
                }
            }
        }
        
        return nil
    }
}

class Utility:NSObject{
    
    /**
    把 WebService Get 所需要傳遞的資料組成 QueryString
    比方說 我想要產生 a=1&b=2 的字串
    需要呼叫 FromDictionaryToQueryString(["a":"1","b":"2"])
    
    :param: d 用一個字典存傳輸的key和對應的value
    
    :returns: 組成QueryString
    */
    class func FromDictionaryToQueryString(d:[String:String])->String{
        
        var params = map(d) { (key, value)->String in
            return "\(key.escaped)=\(value.escaped)"
        }
        return join("&", params)
    }

    
    class func parseJson(json:String)->[AnyObject]{
        var data:NSData! = json.dataUsingEncoding(NSUTF8StringEncoding)
        var parseError: NSError?
        let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions.AllowFragments,
            error:&parseError)
        
        if let parsedObject = parsedObject as? NSArray {
            return parsedObject as [AnyObject]
        }
        if let parsedObject: AnyObject = parsedObject {
            return [parsedObject]
        }
        return []
    }
    
    class func toJson(dic:AnyObject) -> NSData?{
        return NSJSONSerialization.dataWithJSONObject(dic, options:NSJSONWritingOptions(0), error: nil)
    }
    
    class func toJsonString(dic:AnyObject) -> String {
        
        var data = toJson(dic)
        
        if let data = data{
            return NSString(data: data, encoding: NSUTF8StringEncoding) as? String ?? ""
        }else{
            return ""
        }
    }
}

