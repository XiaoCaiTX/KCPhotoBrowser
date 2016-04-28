//
//  HomeController.swift
//  PhotoBrowser
//
//  Created by Kevin on 16/4/27.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class HomeController: UICollectionViewController {
    // MARK:- 懒加载数据
    private lazy var shops : [Shop] = [Shop]()
    private lazy var photoBrowserAnimator = PhotoBrowserAnimator()
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        loadDate(0)
    }
}

// MARK:- 展示大图
extension HomeController{
    func showBigPicture (indexPath : NSIndexPath) {
        //1.创建photoBrowser控制器
       let photoBrowserVc = PhotoBrowserController()
        
        //2.给photoBrowserVc传递indexPath 和 数组
        photoBrowserVc.indexPath = indexPath
        photoBrowserVc.shops = shops
        
        //3.设置modal样式
      //photoBrowserVc.modalTransitionStyle = .FlipHorizontal
        photoBrowserVc.modalPresentationStyle = .Custom
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        
        //4.给photoBrowserAnimator设置值
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.presentDelegate = self
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        
        //5.弹出图片浏览器
        presentViewController(photoBrowserVc, animated: true, completion: nil)
    }
}
/*********************|presentDeletare|**************************/
// MARK:- 遵守&实现presentDeletare中的方法
extension HomeController : PresentDelegate {
    func homeRect(indexPath: NSIndexPath) -> CGRect {
        //1.取出cell
        let cell = (collectionView?.cellForItemAtIndexPath(indexPath))!
        
        //2.把cell当前的坐标点转成--->window的坐标点
        let homeFrame = collectionView!.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        
        return homeFrame
    }
    
    func photoBrowserRect(indexPath: NSIndexPath) -> CGRect {
        //1.取出cell
        let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! HomeViewCell
        //2.取出cell中显示的图片
        let image = cell.imageView.image
        
        //3.计算image方法之后的frame
        return calculateFrame(image!)
        
    }
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        //1.创建imageView对象
        let imageView = UIImageView()
        
        //2.设置显示的图片
        //2.1取出cell
        let cell = (collectionView?.cellForItemAtIndexPath(indexPath))! as! HomeViewCell
        //2.2取出cell中显示的图片
        let image = cell.imageView.image
        
        //2.3设置图片
        imageView.image = image
        
        //3.设置imageView的属性
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}


// MARK:- 发送网络请求
extension HomeController{
    //加载数据
    private func loadDate (offSet : Int) {
        NetworkTools.shareNetworkTool.loadHomeDate(offSet) {(result, error) -> () in
            //1.错误校验
            if error != nil {
                print(error)
                return
            }
            
            //2.获取结果
            guard let resultArray = result else {
                print("获取结果正确")
                return
            }
            
            //3.遍历的结果
            for resultDict in resultArray {
                print(resultDict)
                let shop = Shop(dict: resultDict)
                self.shops.append(shop)
            }
            //4.刷新数据
            self.collectionView?.reloadData()
            
        }
    }
}


// MARK:- 数据源和代理方法
extension HomeController {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.shops.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1. 常见cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! HomeViewCell
        
        //2.设置cell数据
        cell.shop = shops[indexPath.item]
        
        //3.判断是否哦是最后一个cell出现在屏幕
        if indexPath.item == self.shops.count - 1 {
           loadDate(self.shops.count)
        }
        return cell
    }
 
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        showBigPicture(indexPath)//传递给图片浏览器控制器

    }
}