//
//  PhotoBrowserController.swift
//  PhotoBrowser
//
//  Created by Kevin on 16/4/28.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

class PhotoBrowserController: UIViewController {
    // MARK:- 定义属性
    let PhotoBrowsercell = "PhotoBrowsercell"
    
    var indexPath : NSIndexPath?
    var shops : [Shop]?
    
    // MARK:- 懒加载控件
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserFlowLayout())
    lazy var closeBtn =  UIButton(title: "关 闭", bgColor: UIColor.darkGrayColor(), fontSize:16 )
   lazy var saveBtn = UIButton(title: "保 存", bgColor: UIColor.darkGrayColor(), fontSize: 16)

    // MARK:- 系统回调函数
    override func loadView() {
        super.loadView()
        
        view.frame.size.width += 15//滑动间距
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.设置UI界面
        setupUI()
        
        //2.滚动到对应的位置,显示对应的图片
        collectionView.scrollToItemAtIndexPath(indexPath!, atScrollPosition: .Left, animated: false)
    }

}

// MARK:- 实现dismissDelegate中的方法
extension PhotoBrowserController : DismissDelegate{
    func currentIndexPath() -> NSIndexPath {
        //1.获取正在显示的cell
        let cell  = collectionView.visibleCells().first!//获取当前可见的第一个cell
        
        //2.获取indexPath
        //该方法通过一个cell获得对应的indexPath
        return collectionView.indexPathForCell(cell)!
    }
    
    func imageView() -> UIImageView {
        //1.创建UIImageView对象
        let imageView = UIImageView()
        
        //2.设置imageView对象的图片
        //2.1 获取正在显示的cell
        let cell = collectionView.visibleCells().first as! PhotoBrowserCell
        
        //2.2取出图片
        imageView.image = cell.imageView.image
        
        //3 设置imageView的属性
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}



// MARK:- 设置UI界面
extension PhotoBrowserController {
    func setupUI () {
        //1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        //2.设置frame
        collectionView.frame = view.bounds

        let closeBtnY :CGFloat = UIScreen.mainScreen().bounds.size.height - 32 - 20
        closeBtn.frame = CGRect(x: 0, y: closeBtnY, width: 90, height: 32)
        let saveBtnX : CGFloat = UIScreen.mainScreen().bounds.width - 90
        saveBtn.frame = CGRect(x: saveBtnX, y: closeBtnY, width: 90, height: 32)
        
        //3.设置两个按钮的属性
        closeBtn.addTarget(self, action: "closeBtnClick", forControlEvents: .TouchUpInside)
        saveBtn.addTarget(self, action: "saveBtnClick", forControlEvents: .TouchUpInside)
        
        //4.设置collectionview的相关属性
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoBrowsercell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
    }
}

// MARK:- 时间监听函数
extension PhotoBrowserController {
  @objc private func closeBtnClick () {
    
        dismissViewControllerAnimated(true, completion: nil)
    }
  @objc private func saveBtnClick () {
    //1.取出正在屏幕中显示的Cell
    let cell = collectionView.visibleCells().first as! PhotoBrowserCell
    
    //2.取出对应的image
    let image = cell.imageView.image
    
    //3.写入到相册
    UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    
    }
}

// MARK:- 实现collectionview数据源方法
extension PhotoBrowserController : UICollectionViewDataSource ,UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print((shops?.count)!)

        return shops?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowsercell, forIndexPath: indexPath) as! PhotoBrowserCell
        
        //2.设置cell中的数据
        cell.shop = shops?[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        closeBtnClick()
    }
}
