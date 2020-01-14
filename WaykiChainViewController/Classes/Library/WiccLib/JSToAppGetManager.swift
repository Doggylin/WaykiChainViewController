//
//  JSToAppManager.swift
//  CommApp
//
//  Created by sorath on 2018/10/12.
//  Copyright © 2018年 sorath. All rights reserved.
//

import UIKit
import Photos
//MARK: - 交互/ios端注册--获取信息
//class JSToAPPGetManager:NSObject{
//    class func getAddress() ->String{
//        var address:String = ""
//        
//        let account = AccountManager.getAccount()
//        if account.address.count>10{
//            address = account.address
//        }
//        return address
//    }
//}

extension WebViewJavascriptBridge{
    //*********************************获取*******************************************//
    //获取地址
    func getAddress(){
        self.registerHandler("getAddress") { (data, callBlock) in
            var address:String = ""
            
            let account = AccountManager.getAccount()
            if account.address.count>10{
                address = account.address
            }
            let dic = ["address":address]
            callBlock!(dic)
        }
        
    }
    
    //获取app语言
//    func getAppLanguage(){
//        self.registerHandler("getAppLanguage") { (data, callBlock) in
//            var systemLan:String = "1"
//            if "localLanguage".local == "0"{
//                systemLan = "0"
//            }else if "localLanguage".local == "1"{
//                systemLan = "1"
//            }else if "localLanguage".local == "2"{
//                systemLan = "2"
//            }
//            let dic = ["language":systemLan]
//            callBlock!(dic)
//        }
//    }
    
    //获取钱包渠道号
//    func getAppChannelNo(){
//        self.registerHandler("getAppChannelNo") { (data, callBlock) in
//
//            callBlock!(["channelNo":channelCode,"channelName":channelName])
//        }
//    }
    
    
    //获取钱包版本号
//    func getAppVersion(){
//        self.registerHandler("getAppVersion") { (data, callBlock) in
//
//            callBlock!(["version":appVersion])
//        }
//    }
    //获取app UUID
//    func getUUID(){
//        self.registerHandler("getUUID") { (data, callBlock) in
//            let uuid = UUIDTool.getUUIDInKeychain()
//
//            callBlock!(["UUID":uuid])
//        }
//    }
    //获取助记词
    func getMnemonics(){
        self.registerHandler("getMnemonics") { (data, callBlock) in
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                if let pwd = responseDic["password"]{
                    let account = AccountManager.getAccount()
                    let mnemonics = account.getHelpString(password: pwd)
                    if mnemonics == ""{
                        if let c = callBlock{
                            c(["isComplete":"4010"])
                        }
                        return
                    }
                    callBlock!(["mnemonics":mnemonics,"isComplete":"1","errorMsg":""])
                }
            }
        }
    }
    
    //获取私钥
    func getPrivateKey(){
        self.registerHandler("getPrivateKey") { (data, callBlock) in
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                if let pwd = responseDic["password"]{
                    let account = AccountManager.getAccount()
                    let privateKey = account.getPrivateKey(password: pwd)
                    if privateKey == ""{
                        if let c = callBlock{
                            c(["isComplete":"4010"])
                        }
                        return
                    }
                    callBlock!(["privateKey":privateKey,"isComplete":"1"])
                    return
                }
            }
            callBlock!(["errorMsg":"error","isComplete":"0"])
        }
    }
    
    
    //获取转账签名
    func getTransferSignHex(){
        self.registerHandler("getTransferSignHex") { (data, callBlock) in
            var password:String = ""
            var fee:Double = 0
            var validHeight:Double = 0
            var regId:String = AccountManager.getAccount().regId
            var destAddr:String = ""
            var transferValue:String = ""
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                print(responseDic)
                if let value = responseDic["password"]{
                    password = value
                }
                if let value = responseDic["fee"]{
                    fee = value.toDouble()
                }
                if let value = responseDic["height"]{
                    validHeight = value.toDouble()
                }
                if let value = responseDic["regId"]{
                    regId = value
                }
                if let value = responseDic["destAddr"]{
                    destAddr = value
                }
                if let value = responseDic["transferValue"]{
                    transferValue = value
                }
                
                if !Bridge.checkAddress(destAddr) {
                    if let cb = callBlock{
                        cb(["isComplete":"4030"])
                    }
                    return
                }
                
                let helpStr = AccountManager.getAccount().getHelpString(password: password)
                let privateKey = AccountManager.getAccount().getPrivateKeyFromPwd(password: password)
                if helpStr == ""{
                    
                    if privateKey == ""{
                        if let cb = callBlock{
                            cb(["isComplete":"4010"])
                        }
                        return
                    }
                    
                }
                let signHex =  Bridge.getTransfetWICCHex(withHelpStr: helpStr,privateKey: privateKey, fees: fee, validHeight: validHeight, srcRegId: regId, destAddr: destAddr, transferValue: transferValue)
                callBlock!(["signHex":signHex])
            }
        }
    }
    
    
    ///获取多币种转账签名
    func getUCoinTransferSignHex(){
        self.registerHandler("getUCoinTransferSignHex") { (data, callBlock) in
            var password:String = ""
            var fee:Double = 0
            var feeSymbol = ""
            var coinSymbol = ""
            var momo = ""
            var validHeight:Double = 0
            var regId:String = AccountManager.getAccount().regId
            var destAddr:String = ""
            var transferValue = ""
            let responseDic = JSON.init(data as Any)
                print(responseDic)
                if let value = responseDic["password"].string{
                    password = value
                }
                if let value = responseDic["fee"].string{
                    fee = Bridge.handelNumDivide8(value).toDouble()
                }
                if let value = responseDic["fee"].number{
                    fee = Bridge.handelNumDivide8(value.description).toDouble()
                }

                validHeight = responseDic["height"].double ?? 0

                if let value = responseDic["regId"].string{
                    regId = value
                }
                if let destArr = responseDic["destArr"].array{
                    if (destArr.count == 0){
                        if let cb = callBlock{
                            cb(["errorCode":2200,"errorMsg":"参数错误".local,"result":"","isComplete":"0"])
                        }
                        return
                    }
                    let des = destArr[0]
                    if let value = des["coinSymbol"].string{
                        coinSymbol = value
                    }
                    if let value = des["amount"].string{
                        transferValue = Bridge.handelNumDivide8(value)
                    }
                    if let value = des["amount"].number{
                        transferValue = Bridge.handelNumDivide8(value.description)
                    }
                    if let value = des["destAddr"].string{
                        destAddr = value
                    }
                    
                }
                if let value = responseDic["memo"].string{
                    momo = value
                }
                if let value = responseDic["feeSymbol"].string{
                    feeSymbol = value
                }
                
                if !Bridge.checkAddress(destAddr) {
                    if let cb = callBlock{
                        cb(["errorCode":4030,"isComplete":"0","errorMsg":"接收地址错误".local])
                    }
                    return
                }
                
                let helpStr = AccountManager.getAccount().getHelpString(password: password)
                let privateKey = AccountManager.getAccount().getPrivateKeyFromPwd(password: password)
                if helpStr == ""{
                    
                    if privateKey == ""{
                        if let cb = callBlock{
                            cb(["errorCode":4010,"isComplete":"0"])
                        }
                        return
                    }
                    
                }
            let signHex =  Bridge.getUcoinTXHex(withHelpStr: helpStr,privateKey: privateKey, fees: fee, validHeight: validHeight, srcRegId: regId, destAddr: destAddr, coinSymbol: coinSymbol, transferValue: transferValue, feeSymbol: feeSymbol, memo: momo)
            
            let error = signHex.subString(to: 6)
            if error != "error-"{
                if let c = callBlock{
                    c(["isComplete":"1","errorMsg":"","signHex":signHex])
                }
            }else{
                if let c = callBlock{
                    c(["errorCode":4040,"isComplete":"0","errorMsg":signHex])
                }
            }
            
        }
    }
    
    ///获取多币种合约调用签名
    func getUCoinContractSignHex(){
        self.registerHandler("getUCoinContractSignHex") { (data, callBlock) in
            var password:String = ""
            var fee:Double = 0
            var feeSymbol = ""
            var userId:String = AccountManager.getAccount().regId
            var validHeight:Double = 0
            
            var coinSymbol = ""
            var transferValue = ""
            var appid:String = ""
            var contract = ""
            
            let responseDic = JSON.init(data as Any)
            if let value = responseDic["password"].string{
                password = value
            }
            if let value = responseDic["fee"].string{
                fee = Bridge.handelNumDivide8(value).toDouble()
            }
            if let value = responseDic["fee"].number{
                fee = Bridge.handelNumDivide8(value.description).toDouble()
            }
            
            
            if let value = responseDic["height"].string{
                validHeight = value.toDouble()
            }
            if let value = responseDic["height"].number{
                validHeight = value.doubleValue
            }
            if let value = responseDic["userId"].string{
                userId = value
            }
            
            if let value = responseDic["feeSymbol"].string{
                feeSymbol = value
            }
            
            if let value = responseDic["amount"].string{
                transferValue = Bridge.handelNumDivide8(value)
            }
            if let value = responseDic["amount"].number{
                transferValue = Bridge.handelNumDivide8(value.description)
            }
            
            if let value = responseDic["coinSymbol"].string{
                coinSymbol = value
            }
            if let value = responseDic["contract"].string{
                contract = value
            }
            if let value = responseDic["regId"].string{
                appid = value
            }
            
            let helpStr = AccountManager.getAccount().getHelpString(password: password)
            let privateKey = AccountManager.getAccount().getPrivateKeyFromPwd(password: password)
            if helpStr == ""{
                
                if privateKey == ""{
                    if let cb = callBlock{
                        cb(["isComplete":"4010"])
                    }
                    return
                }
                
            }
            let signHex =  Bridge.getUcoinContractHex(withHelpStr: helpStr,privateKey: privateKey, fees: fee, validHeight: validHeight, srcRegId: userId, appid: appid, coinSymbol: coinSymbol, coinAmount: transferValue, feeSymbol: feeSymbol, contractHex: contract)
            
            let error = signHex.subString(to: 6)
            if error != "error-"{
                if let c = callBlock{
                    c(["isComplete":"1","errorMsg":"","signHex":signHex])
                }
            }else{
                if let c = callBlock{
                    c(["isComplete":"4040","errorMsg":signHex])
                }
            }
            
        }
    }
    
    
    //获取钱包regid
    func getRegId(){
        self.registerHandler("getRegId") { (data, callBlock) in
            let account = AccountManager.getAccount()
            let regId = account.regId

            callBlock!(["regId":regId])
        }
    }
    
    
    //获取状态栏高度
//    func getStatusBarHeight(){
//        self.registerHandler("getStatusBarHeight") { (data, callBlock) in
//            if UIDevice.isX(){
//                callBlock!(["height":"44"])
//            }else{
//                callBlock!(["height":"20"])
//            }
//        }
//    }
    

    
    ///获取token转账签名
    func getContractSignHex(){
        self.registerHandler("getContractSignHex") { (data, cb) in
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                var regId:String = ""
                var appid:String = ""
                var contractStr:String = ""
                var pwd:String = ""
                var height:String = ""
                var fee:String = ""
                var amount:String = ""
                if let value = responseDic["regId"]{
                    regId = value
                }
                if let value = responseDic["appid"]{
                    appid = value
                }
                if let value = responseDic["contract"]{
                    contractStr = value
                }
                if let value = responseDic["password"]{
                    pwd = value
                }
                if let value = responseDic["height"]{
                    height = value
                }
                if let value = responseDic["fee"]{
                    fee = value
                }
                if let value = responseDic["amount"]{
                    amount = value
                }
                let helpStr =  AccountManager.getAccount().getHelpString(password: pwd)
                let privateKey = AccountManager.getAccount().getPrivateKeyFromPwd(password: pwd)
                if helpStr == ""{
                    
                    if privateKey == ""{
                        if let c = cb{
                            c(["isComplete":"4010"])
                        }
                        return
                    }
                    
                }
                let signHex:String = Bridge.getContractHexByContractStr(withHelpStr: helpStr,privateKey: privateKey, blockHeight: height.toDouble(), regessID:regId , appid:appid , contractStr: contractStr, handleValue: amount.toDouble(), fee: fee.toDouble())
                let error = signHex.subString(to: 6)
                if error != "error-"{
                    if let c = cb{
                        c(["signHex":signHex])
                    }
                }else{
                    
                    if let c = cb{
                        c(["isComplete":"4040"])
                    }
                }
            }
        }
    }
    //获取激活签名
    func getActiviteHex(){
        self.registerHandler("getActiviteHex") { (data, callBlock) in
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                var vaildHeight:Double = 0
                var fee:Double = 0.0001
                var password:String = ""
                if let value = responseDic["password"]{
                    password = value
                }
                if let value = responseDic["fee"]{
                    fee = value.toDouble()
                }
                if let value = responseDic["height"]{
                    vaildHeight = value.toDouble()
                }
                
                let helpStr =  AccountManager.getAccount().getHelpString(password: password)
                let privateKey = AccountManager.getAccount().getPrivateKeyFromPwd(password: password)
                if helpStr == ""{
                    if (privateKey == ""){
                        if let c = callBlock{
                            c(["isComplete":"4010"])
                        }
                        return
                    }
                }
                let signHex:String = Bridge.getActrivateHex(withHelpStr: helpStr, privateKey: privateKey, fees: fee, validHeight: vaildHeight)
                callBlock!(["signHex":signHex])
            }
        }
    }
    
    ///获取语言
    func getLanguage(){
        self.registerHandler("getLanguage") { (data, callBlock) in
            let str2=UserDefaults.standard.value(forKey: "langeuage") as! String
            if (str2.contains(find: "zh")){
                if let cb = callBlock{
                    cb(["errorCode":0,"errorMsg":"".local,"result":["lang":"zh"]])
                }
            }else{
                if let cb = callBlock{
                    cb(["errorCode":0,"errorMsg":"".local,"result":["lang":"en"]])
                }
            }
        }
    }
    
    ///获取私钥登陆信息
    func getPrivateKeyLoginMsg(){
        self.registerHandler("getPrivateKeyLoginMsg") { (data, callBlock) in
            
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                var privateKey:String = ""
                var randomStr:String = ""
                var pwd : String = ""
                if let value = responseDic["randomStr"]{
                    randomStr = value
                }
                if let p = responseDic["password"]{
                    pwd = p
                }
                let account = AccountManager.getAccount()
                privateKey = account.getPrivateKey(password: pwd)
                if pwd == "" || randomStr == ""{
                    callBlock!(["error":"param is null"])
                    return
                }
                if privateKey == ""{
                    if let c = callBlock{
                        c(["isComplete":"4010"])
                    }
                    return
                }
                let arr = Bridge.privateKey(toSingHex: privateKey, randomStr: randomStr)
                let pubKey = arr.first
                let signMsg = arr.last
                callBlock!(["signHex":signMsg,"publicKey":pubKey,"channelNo":channelCode,"channelName":channelName,"version":appVersion])
            }
            
        }
    }

    
}

extension WebViewJavascriptBridge{
    func returnCallBlock(callBlock:WVJBResponseCallback?,dic:[String:Any]){
        if callBlock != nil {
            callBlock!(dic)
        }
    }
}

