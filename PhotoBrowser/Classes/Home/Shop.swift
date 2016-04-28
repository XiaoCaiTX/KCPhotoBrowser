//
//  Shop.swift
//  PhotoBrowser
//
//  Created by Kevin on 16/4/28.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

class Shop: NSObject {
    //定义属性
    var q_pic_url : String = ""
    var z_pic_url : String = ""
    
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String){}
   
}
