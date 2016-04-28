//
//  Common.swift
//  PhotoBrowser
//
//  Created by Kevin on 16/4/28.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

// MARK:- 根据一张图片等比例计算frame

func calculateFrame( image : UIImage) -> CGRect {
    let x  : CGFloat = 0
    let width : CGFloat = UIScreen.mainScreen().bounds.width
    let height = width * image.size.height / image.size.width
    let y : CGFloat = (UIScreen.mainScreen().bounds.height - height) * 0.5
    return CGRect(x: x, y: y, width: width, height: height)
}
