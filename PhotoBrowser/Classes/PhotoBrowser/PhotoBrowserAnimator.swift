//
//  PhotoBrowserAnimator.swift
//  PhotoBrowser
//
//  Created by Kevin on 16/4/28.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

// MARK:- 定义协议
/************** 弹出需要以下数据 **********************/
protocol PresentDelegate : class {
    func homeRect (indexPath : NSIndexPath) -> CGRect
    func photoBrowserRect (indexPath : NSIndexPath) ->CGRect
    func imageView (indexPath : NSIndexPath) -> UIImageView
}
/************** 回场需要以下数据 **********************/
protocol DismissDelegate : class {
    func currentIndexPath() -> NSIndexPath
    func imageView() -> UIImageView
}


class PhotoBrowserAnimator: NSObject {
    var isPresented : Bool = false
    
    // 为什么用问号
    //AnimatetonVC设置一个代理属性
    weak var presentDelegate : PresentDelegate?
    weak var dismissDelegate : DismissDelegate?
    var indexPath : NSIndexPath?
}

// MARK:- 实现转场动画的方法
extension PhotoBrowserAnimator :  UIViewControllerTransitioningDelegate{
    //弹出动画交给当前控制器管理
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    //消失动画交给当前控制器管理
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}


// MARK:- 实现转场动画的方法
extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    //1.返回动画执行的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.5
    }
    
    // 2.可以获取转场的上下文: 可以通过上下文后去到执行动画的View
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animateForPresentView(transitionContext) : animateForDismissView(transitionContext)
    }
    
    /*******************淡入**************************/
    func animateForPresentView (transitionContext: UIViewControllerContextTransitioning) {
        // 1.取出弹出的view(控制器的view)
        let presentView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        //2.将将要弹出的view自己加到contrainerView
        transitionContext.containerView()?.addSubview(presentView)
        
        //3.执行动画
        //3.1 获取执行的imageView
        guard let presentDelegate = presentDelegate else {
            return //代理为nil,返回
        }
        
        guard let indexPath = indexPath else {
            return //indexPath为nil,返回
        }
        
        let imageView = presentDelegate.imageView(indexPath)
        
        //3.2将imageView添加到父控件
        transitionContext.containerView()?.addSubview(imageView)
        
        //3.3设置imageView的起始位置
       imageView.frame = presentDelegate.homeRect(indexPath)
        
        //3.4执行动画
        presentView.alpha = 0.0
        transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            
            imageView.frame = presentDelegate.photoBrowserRect(indexPath)
//            presentView.alpha = 1.0
//            imageView.removeFromSuperview()
//            transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
            }) { (_) -> Void in
                presentView.alpha = 1.0
                imageView.removeFromSuperview()//动画完成,移除imageView
                transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                transitionContext.completeTransition(true)
            }
         }
        /******************回场动画**************************/
        func animateForDismissView (transitionContext: UIViewControllerContextTransitioning) {
        //1.取出消失的View
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
         dismissView.removeFromSuperview()//移除
        //2.执行动画
        //2.1 获取执行动画的imageView
            guard let dismissDelegate = dismissDelegate else {
                return
            }
            guard let presentDelegate = presentDelegate else {
                return
            }
            
            let imageView = dismissDelegate.imageView()
            transitionContext.containerView()?.addSubview(imageView)
            //2.2获取当前正在显示的indexPath
            let indexPath = dismissDelegate.currentIndexPath()
            
            //2.3设置起始位置
            imageView.frame = presentDelegate.photoBrowserRect(indexPath)
            
            //2.4执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
//            dismissView.alpha = 0.0
            imageView.frame = presentDelegate.homeRect(indexPath)
            }) { (_) -> Void in
                //移除view
//                dismissView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
   
}
