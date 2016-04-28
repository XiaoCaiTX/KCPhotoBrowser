//
//  NetworkTools.swift
//  AFNetworking的封装
//
//  Created by Kevin on 16/4/27.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit
import AFNetworking

enum RequestType {
    case GET
    case POST
}

class NetworkTools: AFHTTPSessionManager {
    //1. 将NetworkTools设置成单例
    static let shareNetworkTool : NetworkTools = {
        let tools = NetworkTools()
        
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        return tools
    }()
    
}
    // MARK:- 封装网络请求
extension NetworkTools {
    func request (requestype : RequestType, urlString : String, parameters : [String : AnyObject], finished : (result : AnyObject?, error : NSError?) -> ()) {
        
        //1.定义成功后的闭包
        let successCallBack = { (task : NSURLSessionDataTask, result : AnyObject?) -> Void in
            finished(result: result, error: nil)
        }
        
        //2.定义失败后的闭包
        let failreCallBack = { (task : NSURLSessionDataTask?, error : NSError) -> Void in
            finished(result: nil, error: error)
        }
        
        //3.发送网络请求
        if requestype == .GET {
                GET(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failreCallBack)
        }else {
            POST(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failreCallBack)
        }
    
    }
}

// MARK:- 请求首页数据
extension NetworkTools {
    func loadHomeDate (offSet: Int, finished : (result : [[String : AnyObject]]?, error : NSError?) -> ()) {
        
        //1.获取请求的URLString
        let urlString  = "http://mobapi.meilishuo.com/2.0/twitter/popular.json"
        
        //2.获取请求参数
        let parameters = ["offset" : "\(offSet)", "limit" : "30", "access_token" : "b92e0c6fd3ca919d3e7547d446d9a8c2"]
        
        //3.发送网络请求
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) -> () in
            //1.判断是否有错误
            if error != nil {
                finished (result: nil, error: error)
            }
            
            //2.获取结果
            guard let result = result as? [String : AnyObject] else{
                finished (result: nil, error: NSError(domain:"data error", code: -1011, userInfo : nil))
                return
            }

            //3.将结果回调
            finished (result: result["data"] as? [[String : AnyObject]], error: nil)
            
        }
    }
}

