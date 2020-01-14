//
//  JSToAppNotifyManager.swift
//  CommApp
//
//  Created by sorath on 2018/10/13.
//  Copyright © 2018年 sorath. All rights reserved.
//

import UIKit
import Photos
import AVKit
import SVProgressHUD
//MARK: - 交互/ios端注册--行为
extension WebViewJavascriptBridge{
    //*********************************行为*******************************************//
    //通知app发起登出
    
    //通知app 保存图片
//    func notifyAppSaveImage(){
//        self.registerHandler("notifyAppSaveImage") { (data, callBlock) in
//            let requestDic = data as! Dictionary<String,Any>
//            var imageBase64 = requestDic["image"] as! String
//            //去除base64 编码的前缀
//            if imageBase64.contains("data:image/png;base64,"){
//                imageBase64 = imageBase64.subString(from: "data:image/png;base64,".length)
//
//            }
//
//            let imageData = Data(base64Encoded: imageBase64, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
//            if let image = UIImage(data: imageData!){
//                PHPhotoLibrary.shared().performChanges({
//                    _ = PHAssetChangeRequest.creationRequestForAsset(from: image)
//
//                }, completionHandler: { (isSuccess, error) in
//                    if isSuccess{
//                        UILabel.showSucceedHUD(text: "保存成功".local)
//                        let dic = ["isComplete":"1"]
//                        self.returnCallBlock(callBlock: callBlock, dic: dic)
//                    }else{
//                        UILabel.showFalureHUD(text: "保存失败".local)
//                        let dic = ["isComplete":"0"]
//                        self.returnCallBlock(callBlock: callBlock, dic: dic)
//                    }
//
//                })
//            }
//
//        }
//    }
    
    //通知app唤起扫一扫
//    func notifyAppScan(){
//        self.registerHandler("notifyAppScan") { (data, callblock) in
//            var isComplete = "0"
//            AuthorityManager.isRightCamera {
//                let scanner =  HMScannerController.scanner(withCardName: "", avatar: UIImage.init(named: "avatar"), completion: {
//                     (stringValue:String?) in
//                    UIApplication.shared.statusBarStyle = .default
//                    if let str = stringValue{
//                        let address = str
//                        isComplete = "1"
//
//                        self.returnCallBlock(callBlock: callblock, dic: ["address":address,"isComplete":isComplete])
//
//                    }else{
//                        UILabel.showFalureHUD(text: "无法扫描到二维码，请重试".local)
//                        self.returnCallBlock(callBlock: callblock, dic: ["isComplete":isComplete])
//                    }
//
//                })
//                scanner?.setTitleColor(UIColor.white, tintColor:UIColor.red)
//                scanner!.modalPresentationStyle = .fullScreen
//                UIApplication.shared.keyWindow?.rootViewController?.present(scanner!, animated: true, completion: nil)
//            }
//        }
//    }
    
    //通知app发起分享
//    func notifyAppShare(){
//        self.registerHandler("notifyAppShare") { (data, callBlock) in
//            var isComplete = "0"
//            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
//                let type = responseDic["type"]
//                let content = responseDic["content"]
//
//                var vc:UIViewController?
//                vc = UIApplication.shared.keyWindow?.rootViewController
//
//
//                UMShareManager.shared(vc: vc).setShareUI(content: content!, type: type!, title: responseDic["title"], descr: responseDic["descr"],image:responseDic["image"], appType: "", complete: { (status) in
//                    if status == 1{
//                        isComplete = "1"
//                    }else if status == 2{
//                        isComplete = "2"
//                    }
//                    self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
//                })
//                return
//            }
//            self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
//        }    }
    
    //通知app播放视频呢
//    func notifyAppPlayVideo(){
//        self.registerHandler("notifyAppPlayVideo") { (data, callBlock) in
//            var isComplete = "0"
//            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
//                if let url = responseDic["url"]{
//                    if url == ""{
//                        self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
//                        return
//                    }
//                    let videoUrl = url.urlEncoded()
//                    //控制器推出的模式
//                    let player = AVPlayer(url: URL(string: videoUrl)!)
//                    let playerViewController = AVPlayerViewController()
//                    playerViewController.player = player
//                    OtherTools.getShowVC().present(playerViewController, animated:true, completion: nil)
//                    isComplete = "1"
//                }
//
//            }
//            self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
//        }
//    }
    

    
    //通知app修改钱包密码
    func notifyAppRevisePassword(){
        self.registerHandler("notifyAppRevisePassword") { (data, callBlock) in
            var isComplete = "0"
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                var newPassword:String = ""
                var oldPassword:String = ""
                if let value = responseDic["newPassword"]{
                    newPassword = value
                }
                if let value = responseDic["oldPassword"]{
                    oldPassword = value
                }
                
                let account = AccountManager.getAccount()
                let isEqual = account.checkAndUpdatePassword(oldPassword: oldPassword, nPassword: newPassword)
                if isEqual  ==  false {
                }else{
                    isComplete = "1"
                }
                
            }
            self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
        }
    }
    
    //通知app选择图片/拍照
//    func notifyAppSelectImagesOrPhotograph(){
//        self.registerHandler("notifyAppSelectImagesOrPhotograph") { (data, callBlock) in
//            if let responseDic:Dictionary<String,Any> = data as? Dictionary<String, Any>{
//                var num = 1
//                if let v = responseDic["num"]{
//                    if v is Int{
//                        num = v as! Int
//                    }else if v is String{
//                        let numStr = v as! String
//                        if Int(numStr) != nil{
//                            num = Int(numStr)!
//                        }
//                    }
//                }
//                SelectImagesManager.shared(vc: OtherTools.getShowVC()).showAlert(num: num, complete: { (arrs, image) in
//                    if arrs != nil{
//                        self.returnCallBlock(callBlock: callBlock, dic: ["images":arrs as Any,"image":"","isComplete":"1","type":"0"])
//                    }else if image != nil{
//                        self.returnCallBlock(callBlock: callBlock, dic: ["images":[],"image":image as Any,"isComplete":"1","type":"1"])
//                    }else{
//                        self.returnCallBlock(callBlock: callBlock, dic: ["images":[],"image":"","isComplete":"0","type":"0"])
//                    }
//                })
//                return
//            }
//            self.returnCallBlock(callBlock: callBlock, dic: ["images":[],"image":"","isComplete":"0","type":"0"])
//        }
//    }

    //通知app进入拍照界面
//    func notifyAppPhotograph(){
//        self.registerHandler("notifyAppPhotograph") { (data, callBlock) in
//            SelectImagesManager.shared(vc: OtherTools.getShowVC()).startPhotograph(selectedimage: { (base64) in
//                self.returnCallBlock(callBlock: callBlock, dic: ["image":base64])
//            })
//
//        }
//    }
    


    
    //创建
    //通知app创建一个全新的钱包（不保存）
    func notifyAppCreateNewAccount(){
        self.registerHandler("notifyAppCreateNewAccount") { (data, callBlock) in
            var isComplete = "0"
            var mHash = ""
            var address = ""
            var helpStr = ""
            let gToken = ""
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                var password:String = ""
                if let value = responseDic["password"]{
                    password = value
                }
                if password.count == 0{
                    self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
                    return
                }
                
                isComplete = "1"
                helpStr = Bridge.createNewWalletMnemonics()
                if Bridge.checkMnemonicCode( helpStr) == false{
                    self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
                    return
                }
                let addressAndPrivateKeyArr = Bridge.getAddressAndPrivateKey(withHelp: helpStr) as! [String]
                address = addressAndPrivateKeyArr[0]
                mHash = Bridge.getWalletHash(from: helpStr)
                let dic = ["isComplete":isComplete,"helpStr":helpStr,"address":address,"mhash":mHash,"token":gToken]
                self.returnCallBlock(callBlock: callBlock, dic: dic as [String : Any])
                return
            }
            let dic = ["isComplete":isComplete,"helpStr":helpStr,"address":address,"mhash":mHash,"token":gToken]
            self.returnCallBlock(callBlock: callBlock, dic: dic as [String : Any])
        }
    }
    
    ///通知app删掉钱包
    
    func deleteWallet(){
        self.registerHandler("deleteWallet") { (data, callBlock) in
            var isComplete = "0"
            
            let json = JSON.init(data as Any)
        
            var password:String = ""
            
            if let pwd = json["password"].string{
                password = pwd
            }
            
            if password.count == 0{
                self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete,"msg":"password is error"])
                return
            }
            let account = AccountManager.getAccount()
            
            let pwdIsTrue = account.checkPassword(inputPassword: password)
            if !pwdIsTrue{
                self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete,"msg":"password is error"])
                return
            }
            
            let newAccount = NewAccount()
            newAccount.token = ""
            newAccount.regId = ""
            newAccount.address = ""
            AccountManager.saveAccount(account: newAccount)
            
            if #available(iOS 9.0, *) {
                let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
                let dateFrom = Date.init(timeIntervalSince1970: 0)
                WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom){}
            } else {
                // Fallback on earlier versions
            }

            
            isComplete = "1"
            self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
            
        }
    }
    
    
    
    
    //通知app保存传入的钱包信息
    func notifyAppSaveWallet(){
        self.registerHandler("notifyAppSaveWallet") { (data, callBlock) in
            var isComplete = "0"
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                var password:String = ""
                var helpStr:String = ""
                if let value = responseDic["password"]{
                    password = value
                }
                if let value = responseDic["helpStr"]{
                    helpStr = value
                }
                if password.count == 0 || helpStr.count == 0{
                    self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
                    return
                }
                if Bridge.checkMnemonicCode( helpStr) == false{
                    self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
                    return
                }
                isComplete = "1"
                let addressAndPrivateKeyArr = Bridge.getAddressAndPrivateKey(withHelp: helpStr) as! [String]
                let address:String = addressAndPrivateKeyArr[0]

                let newAccount = NewAccount()
                newAccount.token = AccountManager.getAccount().token
                newAccount.regId = ""
                newAccount.address = address
                newAccount.setEncyptHelpStringAndPassword(helpStr: helpStr, password: password)
                AccountManager.saveAccount(account: newAccount)

            }
            self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])

        }
    }
    
    //通知app检验传入助记词，如果正确，则拆解为地址和mhash
    func notifyAppCheckMnemonics(){
        self.registerHandler("notifyAppCheckMnemonics") { (data, callBlock) in
            var isComplete = "0"
            var password:String = ""
            var helpStr:String = ""
            var isMnCorrectness = "0"
            var mHash = ""
            var address = ""
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
     
                if let value = responseDic["password"]{
                    password = value
                }
                if let value = responseDic["helpStr"]{
                    helpStr = value
                }
                if password.count == 0 || helpStr.count == 0{
                    self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete,"mnCorrectness":isMnCorrectness,"helpStr":"","address":"","mhash":""])
                    return
                }
                if Bridge.checkMnemonicCode( helpStr) == false{
                    self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete,"mnCorrectness":isMnCorrectness,"helpStr":"","address":"","mhash":""])
                    return
                }
                isComplete = "1"
                isMnCorrectness = "1"
                let addressAndPrivateKeyArr = Bridge.getAddressAndPrivateKey(withHelp: helpStr) as! [String]
                address = addressAndPrivateKeyArr[0]
                mHash = Bridge.getWalletHash(from: helpStr)

            }
            self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete,"mnCorrectness":isMnCorrectness,"helpStr":helpStr,"address":address,"mhash":mHash])

        }
    
    }
    
    //通知app检验传入的私钥，通过私钥导入钱包
    func notifyAppCheckPrivateKey(){
        self.registerHandler("notifyAppCheckPrivateKey") { (data, callBlock) in
            var isComplete = "0"
            var password:String = ""
            var privateKey:String = ""
            var isMnCorrectness = "0"
            var address = ""
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                
                if let value = responseDic["password"]{
                    password = value
                }
                if let value = responseDic["privateKey"]{
                    privateKey = value
                }
                if password.count == 0 || privateKey.count == 0{
                    self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete,"mnCorrectness":isMnCorrectness,"address":""])
                    return
                }
                if Bridge.checkPrivateKey(privateKey) == false{
                    self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete,"isCorrect":isMnCorrectness,"address":""])
                    return
                }
                isComplete = "1"
                isMnCorrectness = "1"
                address = Bridge.getAdressFromePrivateKey(privateKey)
                
            }
            
            
            let newAccount = NewAccount()
            newAccount.address = address
            newAccount.regId = ""
            newAccount.setEncyptPrivateKeyAndPassword(privateKey: privateKey, password: password)
            AccountManager.saveAccount(account: newAccount)
            
            self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete,"isCorrect":isMnCorrectness,"address":address])
            
        }
        
    }
    
    //通知app保存regid
    func notifyAppSaveRegId(){
        self.registerHandler("notifyAppSaveRegId") { (data, callBlock) in
            var isComplete = "0"
 
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                var regId:String = ""
                if let value = responseDic["regId"]{
                    regId = value
                }
                isComplete = "1"
                let account = AccountManager.getAccount()
                account.regId = regId
                AccountManager.saveAccount(account: account)

            }
            self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
        }
    }
    
    
    //通知app切换语言
    func changeLanguage(){
        self.registerHandler("changeLanguage") { (data, callBlock) in
            var isComplete = "0"
            
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                var lang:String = ""
                if let value = responseDic["lang"]{
                    lang = value
                }
                if lang == "en"{
                    LocalizationTool.shareInstance.setLanguage(langeuage: "en")
                }else{
                    LocalizationTool.shareInstance.setLanguage(langeuage: "zh-Hans")
              
                }
                isComplete = "1"
                
            }
            self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
        }
    }
    
    //通知app更新
//    func notifyAppUpdate(){
//        self.registerHandler("notifyAppUpdate") { (data, callBlock) in
//
//            let v = UpdateAppHandle()
//            let keyV = UIApplication.shared.keyWindow?.rootViewController
//            keyV!.definesPresentationContext = true;
//            v.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//
//            v.cheackVersion { (res) in
//                let m = UpdateM.analysisData(json: res)
//                if m.是否升级 != -1{
//                    v.model = m
//                    keyV?.present(v, animated: false, completion: nil)
//                }else{
////                    SVProgressHUD.show(UIImage.init(named: ""), status: "当前已是最新版本".local)
//                }
//            }
//
//            self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":"1"])
//        }
//    }
    
    //通知app改变状态栏颜色
    func changeStatusTextColor(){
        self.registerHandler("changeStatusTextColor") { (data, callBlock) in
            
            if let responseDic:Dictionary<String,Any> = data as? Dictionary<String, Any>{
                let type = responseDic["type"] as! Int
                if type == 0{
                    UIApplication.shared.statusBarStyle = .default
                }else{
                    UIApplication.shared.statusBarStyle = .lightContent
                }
            
            }
            
            self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":"1"])
        }
    }
    
    //通知app用浏览器打开url
    func notifyAppOpenUrl(){
        self.registerHandler("notifyAppOpenUrl") { (data, callBlock) in
            let responseDic = data as! Dictionary<String, Any>
            if let url:String = responseDic["url"] as? String{
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL.init(string: url)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL.init(string: url)!)
                }
            }
            let dic = ["isComplete":"1"]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
    
    //通知app第三方链接
//    func notifyAppjumpThirdUrl(){
//        self.registerHandler("notifyAppjumpThirdUrl") { (data, callBlock) in
//            let responseDic = data as! Dictionary<String, Any>
//            if let url:String = responseDic["url"] as? String{
//
//                var rootVc = UIApplication.shared.keyWindow?.rootViewController
//                while rootVc?.presentedViewController !=  nil{
//                    rootVc = rootVc?.presentedViewController
//                }
//                let vc = ShowThirdUrlController()
//                vc.url = url
//                vc.modalPresentationStyle = .fullScreen
//                rootVc?.present(vc, animated: true, completion: {})
//            }
//            let dic = ["isComplete":"1"]
//            self.returnCallBlock(callBlock: callBlock, dic: dic)
//        }
//    }
    
    //通知app打开pdf
//    func notifyAppOpenPDF(){
//        self.registerHandler("notifyAppOpenPDF") { (data, callBlock) in
//            let responseDic = data as! Dictionary<String, Any>
//            if let url:String = responseDic["url"] as? String{
//
//                var rootVc = UIApplication.shared.keyWindow?.rootViewController
//                while rootVc?.presentedViewController !=  nil{
//                    rootVc = rootVc?.presentedViewController
//                }
//                let vc = ShowThirdUrlController()
//                vc.url = url
//                if let title:String = responseDic["title"] as? String{
//                    vc.mytitle = title
//                }
//                vc.modalPresentationStyle = .fullScreen
//                rootVc?.present(vc, animated: true, completion: {})
//            }
//            let dic = ["isComplete":"1"]
//            self.returnCallBlock(callBlock: callBlock, dic: dic)
//        }
//    }
    //通知app下载并保存图片
//    func notifyAppDownloadImage(){
//        self.registerHandler("notifyAppDownloadImage") { (data, callBlock) in
//            var isComplete = "0"
//            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
//                var urlStr = ""
//                if let value = responseDic["url"]{
//                    urlStr = value
//                }
//                urlStr = urlStr.urlEncoded()
//                if AuthorityManager.isRightPL(){
//                    UrlImageDownloadManager.downloadImage(urlStr: urlStr, complete: { (isSuccess) in
//                        if isSuccess{
//                            isComplete = "1"
//                        }
//                        self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
//                    })
//                }else{
//                    //没有相册权限
//                    let alertC = UIAlertController(title: "提示".local, message: "尚未开启相册权限,您可以去设置中开启".local, preferredStyle: UIAlertController.Style.alert)
//                    let cancelAction = UIAlertAction(title: "取消".local, style: .cancel, handler: nil)
//                    let okAction = UIAlertAction(title: "确定".local, style: .default) { (action) in
//                        let url =  URL(string: UIApplication.openSettingsURLString)
//                        if #available(iOS 10.0, *) {
//                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//                        } else {
//                            UIApplication.shared.openURL(url!)
//                        }
//                    }
//                    alertC.addAction(cancelAction)
//                    alertC.addAction(okAction)
//                    var rootVC = UIApplication.shared.keyWindow?.rootViewController
//                    while rootVC?.presentedViewController !=  nil{
//                        rootVC = rootVC?.presentedViewController
//                    }
//                    rootVC?.present(alertC, animated: true, completion: nil)
//                    //没有权限
//                    self.returnCallBlock(callBlock: callBlock, dic: ["isComplete":isComplete])
//                }
//            }
//
//        }
//    }
    
    

    /**
     *钱包插件
     */
    
    ///进行钱包插件进行合约调用
    func walletPluginContractInvoke(){
        self.registerHandler("walletPluginContractInvoke") { (data, callBlock) in
            if let responseDic:[String:Any] = data as? Dictionary<String, Any>{
                var regId:String = ""
                var contractFild:String = ""
                var inputAmount:String = "0"
                var remark:String = ""
                
                if let value = responseDic["regId"] as? String{
                    regId = value
                }
                if let value = responseDic["contractField"] as? String{
                    contractFild = value
                }
                if let value = responseDic["inputAmount"] as? String{
                    inputAmount = (value.toDouble() / 100000000).description
                }
                if let value = responseDic["remark"] as? String{
                    remark = value
                }
                if (regId == "" || contractFild == ""){
                    if let cb = callBlock{
                        cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                    }
                    return
                }
                if (AccountManager.getAccount().address == ""){
                    if let cb = callBlock{
                        cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                    }
                    return
                }
                if (AccountManager.getAccount().regId == ""){
                    if let cb = callBlock{
                        cb(["errorCode":2100,"errorMsg":"请先激活钱包。".local,"result":""])
                    }
//                    SVProgressHUD.showError(withStatus: "请先激活钱包。".local)
                    return
                }
                callback = callBlock
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"0","arr":[regId,contractFild,inputAmount,remark]])

            }
        }
    }
    
    ///进行钱包插件发布合约
    func walletPluginContractIssue(){
        self.registerHandler("walletPluginContractIssue") { (data, callBlock) in
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                var contractDesc:String = ""
                var contractContent:String = ""
                
                if let value = responseDic["contractDesc"]{
                    contractDesc = value
                }
                if let value = responseDic["contractContent"]{
                    contractContent = value
                }
                if (contractContent == ""){
                    if let cb = callBlock{
                        cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                    }
                    return
                }
                if (AccountManager.getAccount().address == ""){
                    if let cb = callBlock{
                        cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                    }
                    
                    return
                }
//                if (AccountManager.getAccount().regId == ""){
//                    if let cb = callBlock{
//                        cb(["errorCode":2100,"errorMsg":"请先激活钱包。".local,"result":""])
//                    }
//                    SVProgressHUD.showError(withStatus: "请先激活钱包。".local)
//                    return
//                }
                callback = callBlock
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"1","arr":[contractDesc,contractContent]])
                
            }
        }
    }
    
    ///进行钱包插件转账
    func walletPluginTransfer(){
        self.registerHandler("walletPluginTransfer") { (data, callBlock) in
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                var amount:String = ""
                var collectionAddress:String = ""
                var remark:String = ""

                if let value = responseDic["amount"]{
                    amount = (value.toDouble() / 100000000).description
                }
                if let value = responseDic["collectionAddress"]{
                    collectionAddress = value
                }
                if let value = responseDic["remark"]{
                    remark = value
                }
                if (amount == "" || collectionAddress == ""){
                    if let cb = callBlock{
                        cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                    }
                    return
                }
                if !Bridge.checkAddress(collectionAddress) {
                    if let cb = callBlock{
                        cb(["errorCode":2200,"errorMsg":"目的地地址错误。".local,"result":""])
                    }
//                    SVProgressHUD.showError(withStatus: "目的地地址错误。".local)
                    return
                }
                if (AccountManager.getAccount().address == ""){
                    if let cb = callBlock{
                        cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                    }
                    return
                }
//                if (AccountManager.getAccount().regId == ""){
//                    if let cb = callBlock{
//                        cb(["errorCode":2100,"errorMsg":"请先激活钱包。".local,"result":""])
//                    }
//                    SVProgressHUD.showError(withStatus: "请先激活钱包。".local)
//                    return
//                }
                callback = callBlock
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"2","arr":[amount,collectionAddress,remark]])

            }
        }
    }
    
    ///进行钱包插件多币种转账
    func walletPluginUCoinTransfer(){
        self.registerHandler("walletPluginUCoinTransfer") { (data, callBlock) in
           
            let json = JSON.init(data as Any)
            var desArr:[JSON] = []
            var remark:String = ""
            
            if let arr = json["destArr"].array{
                desArr = arr
            }
            if let memo = json["memo"].string{
                remark = memo
            }
            
            var coinAmuont = ""
            var coinSymbol = ""
            var desStr = ""
            if let des = desArr[0].dictionary{
                print(des)
                if let amoumt = des["amount"]?.string{
                    if (amoumt == "NaN"){
                        if let cb = callBlock{
                            cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                        }
                        return
                    }
                    coinAmuont = Bridge.handelNumDivide8(amoumt)
                }
                if let symbol = des["coinSymbol"]?.string{
                    coinSymbol = symbol
                }
                if let destAddr = des["destAddr"]?.string{
                    desStr = destAddr
                }
            }
            if (desStr == ""||coinSymbol==""){
                if let cb = callBlock{
                    cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                }
                return
            }
            if (AccountManager.getAccount().address == ""){
                if let cb = callBlock{
                    cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                }
                return
            }
            callback = callBlock
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"3","arr":[coinAmuont,desStr,remark,coinSymbol]])
            
        }
    }
    
    
    ///进行钱包插件多币种合约调用
    func walletPluginUContractInvoke(){
        
        self.registerHandler("walletPluginUContractInvoke") { (data, callBlock) in

            let json = JSON.init(data as Any)

            var amount:String = ""  //币种金额 10^8
            var coinSymbol:String = ""   //币种类型
            var regId:String = ""     //合约appId
            var contract:String = ""  //合约字段
            var memo:String = ""  //备注



            if let value = json["amount"].string{
                amount = Bridge.handelNumDivide8(value)
            }
            if let value = json["coinSymbol"].string{
                coinSymbol = value
            }

            if let value = json["regId"].string{
                regId = value
            }
            if let value = json["contract"].string{
                contract = value
            }
            if let value = json["memo"].string{
                memo = value
            }
            if (AccountManager.getAccount().address == ""){
                if let cb = callBlock{
                    cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                }
                return
            }
            
            if (amount == ""||coinSymbol==""||regId==""||contract==""){
                if let cb = callBlock{
                    cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                }
                return
            }
            
            callback = callBlock
            let walletaddress = AccountManager.getAccount().address
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"4","arr":[walletaddress,regId,contract,amount,memo,coinSymbol]])

        }
    }
    
    ///进行钱包插件节点投票
//    func walletPluginNodeVote(){
//        self.registerHandler("walletPluginNodeVote") { (data, callBlock) in
//            if let responseDic = data as? [String:[[String:String]]]{
//                if (responseDic["nodeList"]!.count > 11){
//                    if let cb = callBlock{
//                        cb(["errorCode":"100","errorMsg":"投票地址数量不能超过11个".local,"result":""])
//                    }
//                    return
//                }
//                if (AccountManager.getAccount().address == ""){
//                    if let cb = callBlock{
//                        cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
//                    }
//
//
//                    return
//                }
//                if (AccountManager.getAccount().regId == ""){
//                    if let cb = callBlock{
//                        cb(["errorCode":2100,"errorMsg":"请先激活钱包。".local,"result":""])
//                    }
//                    SVProgressHUD.showError(withStatus: "请先激活钱包。".local)
//                    return
//                }
//                let vc = ContractUseVc()
//                vc.nodeViewData = responseDic["nodeList"]!
//                vc.callback = callBlock
//                vc.viewType = 3
//                var rootVc = UIApplication.shared.keyWindow?.rootViewController
//                while rootVc?.presentedViewController !=  nil{
//                    rootVc = rootVc?.presentedViewController
//                }
//                vc.modalPresentationStyle = .fullScreen
//                rootVc?.present(vc, animated: true, completion: {})
//            }
//        }
//    }
    
    
    ///获取钱包地址信息
    func getAddressInfo(){
        self.registerHandler("getAddressInfo") { (data, callBlock) in
            if (AccountManager.getAccount().address == ""){
                if let cb = callBlock{
                    cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                }
                
                return
            }
            
            let walletaddress = AccountManager.getAccount().address
            let json = ["address":walletaddress,"network":"mainnet","supplier":"WaykiTimes"]
        
            if let cb = callBlock{
                cb(["errorCode":0,"errorMsg":"","result":JSON(json).dic()])
            }
        }
    }
    
    ///跳转应用中心
//    func jumpToApplication() {
//        self.registerHandler("jumpToApplication") { (data, callBaclk) in
//            var isComplete = "0"
//
//            if let responseDic:[String:Any] = data as? Dictionary<String, Any>{
//                let vc = AppCenterController()
//                vc.showHUD = false
//                vc.newWeb = true
//                if let title = responseDic["title"] as? String{
//                    vc.cTitle = title
//                }
//
//                if let url = responseDic["url"] as? String {
//                    vc.url = url.trimmingCharacters(in: CharacterSet.whitespaces)
//
//                }
//                if let describe = responseDic["describe"] as? String {
//                    vc.describe = describe
//                }
//                if let isLandScape = responseDic["isLandScape"] as? String {
//                    vc.isLandscapeRight = isLandScape == "1" ? true : false
//                }
//                if let appLogo = responseDic["appLogo"] as? String{
//                    vc.appLogo = appLogo
//                }
//                if let type = responseDic["type"] as? String{
//                    vc.type = type
//                }
//                if let attribute = responseDic["attribute"] as? Int{
//                    vc.attribute = attribute.description
//                }
//                if let attribute = responseDic["attribute"] as? String{
//                    vc.attribute = attribute
//                }
//                var rootVc = UIApplication.shared.keyWindow?.rootViewController
//                while rootVc?.presentedViewController !=  nil{
//                    rootVc = rootVc?.presentedViewController
//                }
//                isComplete = "1"
//                vc.modalPresentationStyle = .fullScreen
//                rootVc?.present(vc, animated: true, completion: {})
//            }
//            self.returnCallBlock(callBlock: callBaclk, dic: ["isComplete":isComplete])
//        }
//    }
    
    
    
    
    ///资产发布
    func walletPluginAssetIssue(){
        self.registerHandler("walletPluginAssetIssue") { (data, callBlock) in

            let json = JSON.init(data as Any)



            var assetSymbol:String = ""  //资产简称
            var assetName:String = ""   //资产名字
            var assetSupply:String = ""     //资产数量
            var assetOwnerId:String = ""  //资产拥有人regid
            var assetMintable:String = "false"  //资产是否可增发
            let shouxufei = "550 WICC"


            if let value = json["assetSymbol"].string{
                assetSymbol = value
            }
            if let value = json["assetName"].string{
                assetName = value
            }

            if let value = json["assetSupply"].string{
                assetSupply = (value.toDouble() / 100000000).description
            }
            if let value = json["assetSupply"].int64{
                assetSupply = (value / 100000000).description
            }
            if let value = json["assetOwnerId"].string{
                assetOwnerId = value
            }
            if let value = json["assetMintable"].string{
                if value == "true"{
                    assetMintable = "true"
                }else{
                    assetMintable = "false"
                }

            }
            if let value = json["assetMintable"].bool{
                if value{
                    assetMintable = "true"
                }else{
                    assetMintable = "false"
                }
            }
            if (AccountManager.getAccount().address == ""){
                if let cb = callBlock{
                    cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                }
                return
            }
            if (assetSymbol == ""||assetName==""||assetSupply==""||assetOwnerId==""){
                if let cb = callBlock{
                    cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                }
                return
            }
            callback = callBlock
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"5","arr":[assetSymbol,assetName,assetSupply,assetOwnerId,assetMintable,shouxufei]])

        }
    }
    
    
    ///资产更新
       func walletPluginAssetUpdate(){
           self.registerHandler("walletPluginAssetUpdate") { (data, callBlock) in
               
               let json = JSON.init(data as Any)
                               
               var tokenSymbol:String = ""  //资产简称
               var updateType:String = ""   //资产名字
               var updateValue:String = ""     //资产数量
               
               
               if let value = json["assetSymbol"].string{
                   tokenSymbol = value
               }
               if let value = json["updateType"].string{
                   updateType = value
               }
               
               if let value = json["updateValue"].string{
                   updateValue = value
               }
               if (AccountManager.getAccount().address == ""){
                   if let cb = callBlock{
                       cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                   }
                   return
               }
            if (tokenSymbol == ""||updateType==""||updateValue==""){
                if let cb = callBlock{
                    cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                }
                return
            }
            callback = callBlock
            self.getAssetInfo(assetSymbol: tokenSymbol, updateType: updateType, updateValue: updateValue)
               
           }
       }
    ///updateType 1:资产拥有者 2:资产名称 3:资产数量
    func getAssetInfo(assetSymbol:String,updateType:String,updateValue:String){
        var old_assetName:String = ""   //资产名字
        var old_assetSupply:String = ""     //资产数量
        var old_assetOwnerId:String = ""  //资产拥有人regid
        let shouxufei = "110 WICC"
        RequestHandler.get(url: apiBaseUrl+"/api/wallet/getasset/\(assetSymbol)",parameters: [:], success: { (res) in
            print("旧的资产详情：",res)
            if let code = res["code"].int{
                if code == 0{
                   if let dic = res["data"].dictionary{
                    if let value = dic["assetname"]?.string{
                            old_assetName = value
                        }
                    if let value = dic["owneraddr"]?.string{
                            old_assetOwnerId = value
                        }
                    if let value = dic["totalsupply"]?.number{
                        let a = Double.init(
                            truncating: value)
                        old_assetSupply = "\(a / 100000000.0)"
                        }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"6","arr":[assetSymbol,old_assetName,old_assetSupply,old_assetOwnerId,shouxufei,updateType,updateValue]])
                    }
                    
                }
                else{
                    if let cb = callback{
                        if let str = res["msg"].string{
                            cb(["errorCode":2100,"errorMsg":str,"result":""])
                        }
                        
                    }
                    
                }
            }
            
            
        
        }) { (error) in
            if let cb = callback{
                cb(["errorCode":2100,"errorMsg":error,"result":""])
                
            }
        }
    }
    
    ///CDP质押、追加
    func walletPluginCdpStake(){
        self.registerHandler("walletPluginCdpStake") { (data, callBlock) in
             let json = JSON.init(data as Any)
            var scoinSymbol = "WUSD"
            var scoinNum = "10"
            var bCoinToStake = "20"
            var coinSymbol = "WICC"
            var cdpTxID = ""
            if let value = json["scoinSymbol"].string{
                scoinSymbol = value
            }
            if let value = json["scoinNum"].string{
                scoinNum = Bridge.handelNumDivide8(value)
            }
            if let value = json["scoinNum"].int64{
                scoinNum = Bridge.handelNumDivide8(value.description)
            }
            if let value = json["cdpTxID"].string{
                cdpTxID = value
            }
            if let arr = json["assetMap"].array{
                if arr.count > 0{
                    if let dic = arr.first?.dictionary{
                        if let value = dic["bCoinToStake"]?.string{
                            bCoinToStake = Bridge.handelNumDivide8(value)
                        }
                        if let value = dic["bCoinToStake"]?.int64{
                            bCoinToStake = Bridge.handelNumDivide8(value.description)
                        }
                        if let value = json["coinSymbol"].string{
                            coinSymbol = value
                        }
                    }
                }else{
                    if let cb = callBlock{
                        cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                    }
                }
            }
            
            if (scoinSymbol == ""||scoinNum==""){
                if let cb = callBlock{
                    cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                }
                return
            }
            
            let address = AccountManager.getAccount().address
            if (address == ""){
                if let cb = callBlock{
                    cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                }
                return
            }
            callback = callBlock
            let model1 = ["title":"CDP创建地址".local,"value":address,"symbol":"","canCopy":"1"]
            
            if (cdpTxID == ""){
                let model2 = ["title":"抵押量".local,"value":bCoinToStake,"symbol":coinSymbol,"canCopy":"0"]
                let model3 = ["title":"贷出量".local,"value":scoinNum,"symbol":scoinSymbol,"canCopy":"0"]
                let models = [model1,model2,model3]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"7","dic":["viewData":models,"txID":cdpTxID]])
            }else{
                let model2 = ["title":"CDP创建交易哈希".local,"value":cdpTxID,"symbol":"","canCopy":"1"]  //cdp创建hash
                let model3 = ["title":"追加抵押量".local,"value":bCoinToStake,"symbol":coinSymbol,"canCopy":"0"]
                let model4 = ["title":"追加贷出量".local,"value":scoinNum,"symbol":scoinSymbol,"canCopy":"0"]
                let models = [model1,model2,model3,model4]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"8","dic":["viewData":models,"txID":cdpTxID]])
            }
        }
    }
    
    ///CDP赎回
    func walletPluginCdpRedeem(){
        //walletPluginCdpRedeem
           self.registerHandler("walletPluginCdpRedeem") { (data, callBlock) in
                let json = JSON.init(data as Any)
               var repayNum = ""
               var redeemCoinNum = ""
               var cdpTxID = ""
               var coinSymbol = ""

               if let value = json["repayNum"].string{
                   repayNum = Bridge.handelNumDivide8(value)
               }
               if let value = json["repayNum"].int64{
                    repayNum = Bridge.handelNumDivide8(value.description)
                }
            if let value = json["cdpTxID"].string{
                cdpTxID = value
            }
               if let arr = json["assetMap"].array{
                   if arr.count > 0{
                       if let dic = arr.first?.dictionary{
                           if let value = dic["redeemCoinNum"]?.string{
                               redeemCoinNum = Bridge.handelNumDivide8(value)
                           }
                           if let value = dic["redeemCoinNum"]?.int64{
                               redeemCoinNum = Bridge.handelNumDivide8(value.description)
                           }
                           if let value = dic["coinSymbol"]?.string{
                               coinSymbol = value
                           }
                       }
                   }else{
                       if let cb = callBlock{
                           cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                       }
                   }
               }

               if (repayNum == ""||cdpTxID == ""){
                   if let cb = callBlock{
                       cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                   }
                   return
               }
            let address = AccountManager.getAccount().address
            if (address == ""){
                if let cb = callBlock{
                    cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                }
                return
            }
            let model1 = ["title":"CDP创建地址".local,"value":address,"symbol":"","canCopy":"1"]
            let model2 = ["title":"CDP创建交易哈希".local,"value":cdpTxID,"symbol":"","canCopy":"1"]
            let model3 = ["title":"归还量".local,"value":repayNum,"symbol":"WUSD","canCopy":"0"]
            let model4 = ["title":"赎回量".local,"value":redeemCoinNum,"symbol":coinSymbol,"canCopy":"0"]
            let models = [model1,model2,model3,model4]
            callback = callBlock
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"9","dic":["viewData":models,"txID":cdpTxID]])

           }
       }
    
    
    //CDP清算
    func walletPluginCdpLiquidate(){
           self.registerHandler("walletPluginCdpLiquidate") { (data, callBlock) in
                let json = JSON.init(data as Any)
        

               var assetSymbol = ""
               var liquidateNum = ""
               var cdpTxID = ""

               if let value = json["liquidateNum"].string{
                   liquidateNum = Bridge.handelNumDivide8(value)
               }
               if let value = json["liquidateNum"].int64{
                    liquidateNum = Bridge.handelNumDivide8(value.description)
                }
                if let value = json["assetSymbol"].string{
                    assetSymbol = value
                }
                if let value = json["cdpTxID"].string{
                    cdpTxID = value
                }

               if (assetSymbol == ""||liquidateNum == ""||cdpTxID == ""){
                   if let cb = callBlock{
                       cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                   }
                   return
               }
            let address = AccountManager.getAccount().address
            if (address == ""){
                if let cb = callBlock{
                    cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                }
                return
            }
            let model1 = ["title":"清算人地址".local,"value":address,"symbol":"","canCopy":"1"]
            let model2 = ["title":"CDP创建交易哈希".local,"value":cdpTxID,"symbol":"","canCopy":"1"]
            let model3 = ["title":"清算量".local,"value":liquidateNum,"symbol":"WUSD","canCopy":"0"]
            
            let models = [model1,model2,model3]
            callback = callBlock
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"10","dic":["viewData":models,"txID":cdpTxID,"normalParam":assetSymbol]])
           }
       }
    
    //DEX限价买卖
//    func walletPluginDexLimit(){
//           self.registerHandler("walletPluginDexLimit") { (data, callBlock) in
//                let json = JSON.init(data as Any)
//
//                var dexTxType = "" //Limit_BUY / Limit_SELL
//                var coinType = ""  // 币种
//                var assetType = "" // 资产类型
//                var amount = "" //资产金额
//                var price = "" // 价格*10^8
//
//
//
//               if let value = json["dexTxType"].string{
//                   dexTxType = value
//               }
//               if let value = json["amount"].int64{
//                    amount = Bridge.handelNumDivide8(value.description)
//                }
//                if let value = json["amount"].string{
//                    amount = Bridge.handelNumDivide8(value)
//                }
//                if let value = json["coinType"].string{
//                    coinType = value
//                }
//                if let value = json["assetType"].string{
//                    assetType = value
//                }
//                if let value = json["price"].string{
//                    price = Bridge.handelNumDivide8(value)
//                }
//                if let value = json["price"].number{
//                    price = Bridge.handelNumDivide8(value.description)
//                }
//
//               if (dexTxType == ""||coinType == ""||assetType == ""||amount == ""||price == ""){
//                   if let cb = callBlock{
//                       cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
//                   }
//                   return
//               }
//            if PaySubView.getDexType(dexType: dexTxType) == ""{
//                if let cb = callBlock{
//                    cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
//                }
//                return
//            }
//            let address = AccountManager.getAccount().address
//            if (address == ""){
//                if let cb = callBlock{
//                    cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
//                }
//                return
//            }
//            let model1 = ["title":"数量".local,"value":amount,"symbol":assetType,"canCopy":"0"]
//            let model2 = ["title":"价格".local,"value":price,"symbol":coinType,"canCopy":"0"]
//            let model3 = ["title": dexTxType == "Limit_BUY" ? "花费".local : "获得数量".local,"value":Bridge.handelA_Mul_B_(withA: amount, b: price),"symbol":coinType,"canCopy":"0"]
//
//            let models = [model1,model2,model3]
//            callback = callBlock
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"11","dic":["viewData":models,"txID":dexTxType]])
//           }
//       }
    
    //DEX市价买卖
//    func walletPluginDexMarket(){
//        //walletPluginDexMarket
//           self.registerHandler("walletPluginDexMarket") { (data, callBlock) in
//                let json = JSON.init(data as Any)
//
//                var dexTxType = "" //Market_ BUY/ Market_SELL
//                var coinType = ""  // 币种
//                var assetType = "" // 资产类型
//                var amount = "" //资产金额
//                let price = "以实际成交为准".local // 价格*10^8
//
//
//               if let value = json["dexTxType"].string{
//                   dexTxType = value
//               }
//               if let value = json["amount"].int64{
//                    amount = Bridge.handelNumDivide8(value.description)
//                }
//                if let value = json["amount"].string{
//                    amount = Bridge.handelNumDivide8(value)
//                }
//                if let value = json["coinType"].string{
//                    coinType = value
//                }
//                if let value = json["assetType"].string{
//                    assetType = value
//                }
//
//               if (dexTxType == ""||coinType == ""||assetType == ""||amount == ""){
//                   if let cb = callBlock{
//                       cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
//                   }
//                   return
//               }
//            if PaySubView.getDexType(dexType: dexTxType) == ""{
//                if let cb = callBlock{
//                    cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
//                }
//                return
//            }
//            let address = AccountManager.getAccount().address
//            if (address == ""){
//                if let cb = callBlock{
//                    cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
//                }
//                return
//            }
//            var assets_symbol = ""
//            var coin_symbol = ""
//
//            if (dexTxType == "Market_SELL"){
//                assets_symbol = coinType
//                coin_symbol = assetType
//            }else{
//                assets_symbol = assetType
//                coin_symbol = coinType
//            }
//            let model1 = ["title": dexTxType == "Market_BUY" ? "花费".local : "数量".local,"value":amount,"symbol":coin_symbol,"canCopy":"0"]
//            let model2 = ["title":"预计获得".local,"value":price,"symbol":assets_symbol,"canCopy":"0"]
//
//            let models = [model1,model2]
//            callback = callBlock
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"11","dic":["viewData":models,"txID":dexTxType]])
//           }
//       }
    
    
    //DEX取消交易
//    func walletPluginDexCancelOrder(){
//        //walletPluginDexCancelOrder
//           self.registerHandler("walletPluginDexCancelOrder") { (data, callBlock) in
//                let json = JSON.init(data as Any)
//
//                var dexTxNum = "" //订单号
//
//
//               if let value = json["dexTxNum"].string{
//                   dexTxNum = value
//               }
//
//
//               if (dexTxNum == ""){
//                   if let cb = callBlock{
//                       cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
//                   }
//                   return
//               }
//            let address = AccountManager.getAccount().address
//            if (address == ""){
//                if let cb = callBlock{
//                    cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
//                }
//                return
//            }
//            callback = callBlock
//            self.getDexTxInfo(dexTxNum: dexTxNum,address:address)
//           }
//       }
    
    ///updateType
//    func getDexTxInfo(dexTxNum:String,address:String){
////       let ad = "wTEqRtMuqk2hK9ZskRH47WmC3GoP99Zqv7"
//        RequestHandler.get(url: apiBaseUrl+"/api/wallet/txDetails/\(dexTxNum)/\(address)",parameters: [:], success: { (res) in
//            print("旧的资产详情：",res)
//            if let code = res["code"].int{
//                if code == 0{
//                   if let data = res["data"].dictionary{
//                    var dexType = ""
//                    var price = ""
//                    var assetamount = ""
//                    var assetsymbol = ""
//                    var coinsymbol = ""
//                    var costMoney = ""
//                    if let value = data["txtype"]?.string{
//                        dexType = value
//                    }
//                    if let value = data["price"]?.string{
//                       price = value
//                    }
//
//                    if let value = data["dextradeamount"]?.string{
//                        assetamount = value
//                    }
//                    if let value = data["dexassetsymbol"]?.string{
//                        assetsymbol = value
//                    }
//                    if let value = data["dexcoinsymbol"]?.string{
//                        coinsymbol = value
//                    }
//                    if let value = data["dextrademoney"]?.string{
//                        costMoney = value
//                    }
//                    var symbol1 = ""
//                    var symbol2 = ""
//                    if (dexType == "DEX_MARKET_BUY_ORDER_TX"){
//                        symbol1 = coinsymbol
//                        symbol2 = assetsymbol
//                    }else{
//                        symbol1 = assetsymbol
//                        symbol2 = coinsymbol
//                    }
//                    let model1 = ["title":"订单号".local,"value":dexTxNum,"symbol":"","canCopy":"1"]
//                    let model2 = ["title":"类型".local,"value":self.getDexType(dexType: dexType),"symbol":"","canCopy":"0"]
//                    let model3 = ["title": dexType == "DEX_MARKET_BUY_ORDER_TX" ? "花费".local : "数量".local,"value": dexType == "DEX_MARKET_BUY_ORDER_TX" ? costMoney : assetamount,"symbol":symbol1,"canCopy":"0"]
//                    let model4 = ["title":"价格".local,"value":price,"symbol":coinsymbol,"canCopy":"0"]
//                    let model5 = ["title":dexType == "DEX_LIMIT_BUY_ORDER_TX" ? "花费".local : "获得数量".local,"value":costMoney,"symbol":symbol2,"canCopy":"0"]
//
//                    var models = [Any]()
//                    if dexType.contains(find: "MARKET"){
//                        models = [model1,model2,model3]
//                    }else{
//                        models = [model1,model2,model3,model4,model5]
//                    }
//
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"12","dic":["viewData":models,"txID":dexTxNum]])
//                    }
//
//                }
//                else{
//                    if let cb = callback{
//                        if let str = res["msg"].string{
//                            cb(["errorCode":2100,"errorMsg":str,"result":""])
//                        }
//
//                    }
//
//                }
//            }
//
//
//
//        }) { (error) in
//            if let cb = callback{
//                cb(["errorCode":2100,"errorMsg":error,"result":""])
//
//            }
//        }
//    }
    
    
    
    //授权登陆
       func signMessage(){
           //signMessage
              self.registerHandler("signMessage") { (data, callBlock) in
                   let json = JSON.init(data as Any)
                   
                   var imgUrl = ""
                   var appName = ""
                   let appDesc = "获取您的钱包地址信息".local
                   var appMsg = ""

                    if let value = json["dappLogo"].string{
                        imgUrl = value
                    }
                    if let value = json["dappName"].string{
                        appName = value
                    }
                    if let value = json["message"].string{
                        appMsg = value
                    }
                      

                    if (appMsg == ""||appDesc == ""||appName == ""||imgUrl == ""){
                        if let cb = callBlock{
                           cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                        }
                        return
                    }
                   let address = AccountManager.getAccount().address
                   if (address == ""){
                       if let cb = callBlock{
                           cb(["errorCode":2000,"errorMsg":"Please create or import wallet first.".local,"result":""])
                       }
                       return
                   }
                   callback = callBlock
                
                let model1 = ["title":"授权账号:".local,"value":address,"symbol":"","canCopy":"0"]
                let model2 = ["title":"消息:".local,"value":appMsg,"symbol":"","canCopy":"0"]
               
                let models = [model1,model2]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"13","dic":["viewData":models,"txID":"","appInfo":["imgUrl":imgUrl,"appName":appName,"appDesc":appDesc]]])
                }
              }
    
    //身份认证
    func getIdentity(){
        //signMessage
           self.registerHandler("getIdentity") { (data, callBlock) in
                let json = JSON.init(data as Any)
                
                var imgUrl = ""
                var appName = ""
                var type = "1"  //1 所有信息 2身份证  3 手机号
                
                var appDesc = ""

                 if let value = json["dappLogo"].string{
                     imgUrl = value
                 }
                 if let value = json["dappName"].string{
                     appName = value
                 }
                 if let value = json["type"].string{
                     type = value
                 }
                if let value = json["type"].int{
                    type = value.description
                }
                if (type == "2"){
                    appDesc = "获取您的身份证信息".local
                }else if (type == "3"){
                    appDesc = "获取您的手机号信息".local
                }else{
                    appDesc = "获取您的账户信息".local
                }
                 if (appName == ""||imgUrl == ""){
                     if let cb = callBlock{
                        cb(["errorCode":5000,"errorMsg":"参数错误".local,"result":""])
                     }
                     return
                 }
                callback = callBlock
                let models:[[String:String]] = []
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contractAlert"), object: nil, userInfo: ["type":"14","dic":["viewData":models,"txID":"","appInfo":["imgUrl":imgUrl,"appName":appName,"appDesc":appDesc,"type":type]]])
             }
           }
    ///身份认证错误
    func identityautherror(){
        self.registerHandler("identityautherror") { (data, callBlock) in
            
            let str2 = UserDefaults.standard.value(forKey: "langeuage") as! String
            if (str2.contains(find: "en")){
                if let cb = callBlock{
                    cb(["errorCode":0,"errorMsg":"".local,"result":"身份授权仅支持中文模式下使用".local])
                }
                return
            }
            
            let alert = UIAlertController.init(title: "", message: "您的身份认证有误，需要重新认证".local, preferredStyle:.alert)
            let alertAction = UIAlertAction.init(title: "重新认证".local, style: .default) { (action) in
                
                let rootVC = UIApplication.shared.keyWindow?.rootViewController
                rootVC?.dismiss(animated: true){
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "jsRouteToAuth") , object: nil)
                }
            }
            alert.addAction(alertAction)
            var rootVC = UIApplication.shared.keyWindow?.rootViewController
            while rootVC?.presentedViewController !=  nil{
                rootVC = rootVC?.presentedViewController
            }
            rootVC?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    ///dex交易详情的交易类型
    func getDexType(dexType:String) ->String{
        let dic = [
            "DEX_LIMIT_BUY_ORDER_TX":"限价买入".local,
            "DEX_LIMIT_SELL_ORDER_TX":"限价卖出".local,
            "DEX_MARKET_BUY_ORDER_TX":"市价买入".local,
            "DEX_MARKET_SELL_ORDER_TX":"市价卖出".local,
            "DEX_CANCEL_ORDER_TX":"取消挂单".local
        ]
        if (dic[dexType] != nil){
            return dic[dexType]!
        }
        return ""
    }
    
    
    
}

