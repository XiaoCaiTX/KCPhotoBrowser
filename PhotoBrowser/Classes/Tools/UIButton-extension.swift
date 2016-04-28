//
//  UIButton-extension.swift
//  PhotoBrowser
//
//  Created by Kevin on 16/4/28.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init (title : String, bgColor: UIColor, fontSize: CGFloat) {
        self.init()
        
        setTitle(title, forState: .Normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
}