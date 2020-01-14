//
//  RequestHandler.swift
//  CommApp
//
//  Created by sorath on 2018/10/9.
//  Copyright © 2018年 sorath. All rights reserved.
//

import UIKit

import Alamofire
import SVProgressHUD

enum HUDStyle {
    case none
    case loading
}

let CONNECTFAILD = "Connect error"


enum HTTPClient: URLRequestConvertible {
    
    case info(paramter: [String: Any])
    
    
    private var method: HTTPMethod {
        
        switch self {
        case .info:
            return .post
        }
    }
    
    private var url: String {
        
        switch self {
        case .info:
            return ""
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let urlString = url
        let url = URL(string: urlString)
        var req = URLRequest(url: url!)
//        req.httpMethod = method.re
//        req.setv
        // 设置公共参数
        
        switch self {
        case .info(let paramter):
            return try Alamofire.JSONEncoding.default.encode(req, with: paramter)
        }
    }
}



class RequestHandler: NSObject {
    
    class func post(url:String,parameters:Dictionary<String,Any>,runHUD:HUDStyle = .none,isNeedToken:Bool=true,success: @escaping ((_ json:JSON)->Void),failure:@escaping ((_ error:String)->Void)){
        // 显示加载器
        if runHUD == .loading{ showHUD() }
        // 参数处理
        let parameter:Parameters = parameters
        let uuid:String = UUIDTool.getUUIDInKeychain()
        let requestKey = AccountManager.getAccount().phoneNum.count>0 ? AccountManager.getAccount().phoneNum : "-"
        let requestUUID:String = UUIDTool.createRandomString(withKey: requestKey)
        let timeZone = TimeZone.getOffset()
        var header = ["Accept":"application/json","Content-Type":"application/json","device_uuid":uuid,"request_uuid":requestUUID,"channel_code":channelName,"user_timezone":timeZone]
        if isNeedToken{
            header = addToken(header: header)
        }
//        print("header is",header)
        
        
        Alamofire.request(HTTPClient.info(paramter: parameters)).responseJSON { (response) in
        
                                    if runHUD == .loading { dismissHUD() }
                                    let errorStr = CONNECTFAILD
        
                                    switch response.result.isSuccess {
                                    case true:
                                        if let value = response.result.value {
                                            success(JSON(value))
                                        }
                                        break
                                    case false:
                                        failure(errorStr)
                                        break
                                    }
        
        
        
                }
        
//        Alamofire.request(url, method: .post,
//                          parameters: parameter,
//                          encoding: JSONEncoding,
//                          headers:header).responseJSON { (response) in
//
//                            if runHUD == .loading { dismissHUD() }
//                            let errorStr = CONNECTFAILD
//
//                            switch response.result.isSuccess {
//                            case true:
//                                if let value = response.result.value {
//                                    success(JSON(value))
//                                }
//                                break
//                            case false:
//                                failure(errorStr)
//                                break
//                            }
//
//
//
//        }
    }
    
    
    
    
    class func get(url:String,parameters:Dictionary<String,Any>,runHUD:HUDStyle = .none,isNeedToken:Bool=true,success: @escaping ((_ json:JSON)->Void),failure:@escaping ((_ error:String)->Void) ){
        // 显示加载器
        if runHUD == .loading{ showHUD() }
        // 参数处理
        let parameter:Parameters = parameters
        let uuid:String = UUIDTool.getUUIDInKeychain()
        let requestKey = AccountManager.getAccount().phoneNum.count>0 ? AccountManager.getAccount().phoneNum : "-"
        let requestUUID:String = UUIDTool.createRandomString(withKey: requestKey)
        let timeZone = TimeZone.getOffset()
        var header:[String:String] = ["device_uuid":uuid,"request_uuid":requestUUID,"channel_code":channelCode,"user_timezone":timeZone]
        if isNeedToken{
            header = addToken(header: header)
        }
//        print("get   ",url,header)
        Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers:header).responseJSON { (response) in
            if runHUD == .loading { dismissHUD()}
            
            var errorStr:String?
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    if let dic = JSON(value).dictionary{
                        if let code = dic["code"]?.int{
                            if code == 0{
                                success(JSON(value))
                                return
                            }
                            print("url is ",url,dic)
                          
                            //根据code 显示错误信息
                            if let msg = dic["msg"]?.string{
                                errorStr = msg
                            }
                        }
                    }
                }
            case false:
                let error = response.result.error
                var message : String?
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 400:
                        message = "http code 400"
                    case 401:
                        message = "http code 401"
                    case 402:
                        message = "http code 402"
                    case 403:
                        message = "http code 403"
                    case 404:
                        message = "http code 404"
                    default:
                        message = "Net error"
                    }
                } else {
                    if error?.localizedDescription != nil{
                        message = (error?.localizedDescription)!
                    }
                }
                errorStr = message
            }
            if errorStr == nil{
                errorStr = CONNECTFAILD
            }
            failure(errorStr!)
        }
    }
    
}


extension RequestHandler{
    class func showHUD(){ SVProgressHUD.show() }
    
    class func dismissHUD(){ SVProgressHUD.dismiss() }
    
    
    class func addToken(header:[String:String]) ->[String:String]{
        let account = AccountManager.getAccount()
        var headers = header
        if account.token.count>0 {
            headers["access_token"] = account.token
        }
        return headers
    }


}
