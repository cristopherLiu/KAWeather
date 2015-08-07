//
//  CollectionLayout.swift
//  KAWeather
//
//  Created by hjliu on 2015/8/4.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

class CollectionLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.sectionInset = UIEdgeInsetsZero
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.headerReferenceSize = CGSizeZero
        self.footerReferenceSize = CGSizeZero
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
