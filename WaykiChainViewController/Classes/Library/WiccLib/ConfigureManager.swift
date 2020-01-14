//
//  ConfigureManager.swift
//  CommApp
//
//  Created by sorath on 2018/10/9.
//  Copyright © 2018年 sorath. All rights reserved.
//

import UIKit

enum ChainNet: Int {
    case main = 1
    case test = 2
}

//
//let webUrl = "http://times-www.main.waykitest.com:5556" // 预发布环境
//let apiBaseUrl = "http://times-www.main.waykitest.com:5556/" //
		
//let webUrl = "http://times-www.waykitest.com/"//  内网测试环境
//let apiBaseUrl = "http://times-www.waykitest.com/" //

//let webUrl = "http://m.wtimes.waykitest.com:81/#/"   //开发者环境外网
//let apiBaseUrl = "http://m.wtimes.waykitest.com:81/"
//
let webUrl = "https://m.axcue.com"//   //正式环境
let apiBaseUrl = "https://m.axcue.com/"

var walletNetConfirure:Int = ChainNet.test.rawValue // 1:main,2:test   钱包网络配置,主链or测试链

let isMainNet = true    //api连接域名还是ip
let appVersion:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let channelCode:String = "1"  //预留渠道code
let channelName:String = "comm_ios"  //预留渠道name
var callback : (([String: Any])->Void)? = nil

class ConfigureManager: NSObject {
    
}

