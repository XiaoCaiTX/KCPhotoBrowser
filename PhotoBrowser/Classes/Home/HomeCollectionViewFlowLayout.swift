//
//  HomeCollectionViewFlowLayout.swift
//  PhotoBrowser
//
//  Created by Kevin on 16/4/27.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

class HomeCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        //1.定义常量
        let cols : CGFloat = 3
        let margin : CGFloat = 10
        
        //2.计算item的WH
        let itemHW  = (UIScreen.mainScreen().bounds.width - (cols + 1) * margin) / 3
        print(itemHW)
        
        //3.设置布局内容
        itemSize = CGSize(width: itemHW, height: itemHW)
        minimumInteritemSpacing = margin
        minimumLineSpacing = margin
        
        //4.设置collectionview的内边距
        collectionView?.contentInset = UIEdgeInsetsMake(margin + 64, margin,  margin, margin)
         
    }
}
