//
//  PhotoBrowserCell.swift
//  PhotoBrowser
//
//  Created by Kevin on 16/4/28.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserCell: UICollectionViewCell {
    
    // MARK:- 懒加载属性
     lazy var imageView = UIImageView()
    
    var shop : Shop? {
        didSet {
            //1.nil值校验---->x
            guard let urlString = shop?.q_pic_url else {
                return
            }
            //2.获取小图---->已经加载过了,直接到缓存中取就可以了
            var smallImge = SDWebImageManager.sharedManager().imageCache.imageFromMemoryCacheForKey(urlString)
            if smallImge == nil {//----->打不到,就用占位图
                smallImge = UIImage(named: "empty_picture")
            }
            //计算imageView的frame----->根据一张小图的尺寸等比例计算
            imageView.frame = calculateFrame(smallImge)
            
            //4.设置大图
            guard let bigURLString = shop?.z_pic_url else {
                return
            }
            
            let url = NSURL(string: bigURLString)
            imageView.sd_setImageWithURL(url, placeholderImage: smallImge) { (image, error, type, url) -> Void in
                //设置图片成功回调再计算一次frame
                self.imageView.frame = calculateFrame(image)
              }
        }
    }
    
    
    // MARK:- 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        //添加子控件
        //设置UI界面
        contentView.addSubview(imageView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

