//
//  PhotoBrowserFlowLayout.swift
//  PhotoBrowser
//
//  Created by Kevin on 16/4/28.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

class PhotoBrowserFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        //1.设置布局相关属性
        itemSize = (collectionView?.bounds.size)!
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal

    }
}
