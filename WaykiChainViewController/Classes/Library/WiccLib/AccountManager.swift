//
//  AccountManager.swift
//  WaykiApp
//
//  Created by lcl on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

@objcMembers class NewAccount:NSObject,NSCoding {
    @objc private var passwordEncrypt:String = ""/////md5 32摘要  ,此密码不保存
    @objc private var helpStringEncrypt:String =  ""//加密后部分
    @objc private var privateKeyEncrypt:String =  ""//加密后部分
    var mHash:String =  ""
    var address:String =  ""
    var regId:String = ""
    var validHeight:Double = 0
    var wiccSumAmount:Double = 0    //主币数量
    var tokenSumAmount:Double = 0   //代币数量
    var wiccFSumAmount:Double = 0   //冻结、锁仓wicc数量

    var phoneNum:String = ""        //钱包绑定的账户手机号
    var token:String = ""           //Token,每次启动需要清除
    
    static let instance = NewAccount()    /// 单例
    
    class func shared() ->NewAccount{
        return instance
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(helpStringEncrypt, forKey: "helpStringEncrypt")
        aCoder.encode(privateKeyEncrypt, forKey: "privateKeyEncrypt")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(regId, forKey: "regId")
        aCoder.encode(validHeight, forKey: "validHeight")
        aCoder.encode(mHash, forKey: "mHash")
        aCoder.encode(wiccSumAmount, forKey: "wiccSumAmount")
        aCoder.encode(tokenSumAmount, forKey: "tokenSumAmount")
        aCoder.encode(wiccFSumAmount, forKey: "wiccFSumAmount")

        aCoder.encode(phoneNum, forKey: "phoneNum")
        aCoder.encode(token, forKey: "token")

    }
    
    required init?(coder aDecoder: NSCoder) {
        helpStringEncrypt =  aDecoder.decodeString(forKey: "helpStringEncrypt")
        privateKeyEncrypt =  aDecoder.decodeString(forKey: "privateKeyEncrypt")
        address = aDecoder.decodeString(forKey: "address")
        regId = aDecoder.decodeString(forKey: "regId")
        validHeight = aDecoder.decodeDouble(forKey: "validHeight")
        mHash = aDecoder.decodeString(forKey: "mHash")
        wiccSumAmount = aDecoder.decodeDouble(forKey: "wiccSumAmount")
        tokenSumAmount = aDecoder.decodeDouble(forKey: "tokenSumAmount")
        wiccFSumAmount = aDecoder.decodeDouble(forKey: "wiccFSumAmount")

        phoneNum = aDecoder.decodeString(forKey: "phoneNum")
        token = aDecoder.decodeString(forKey: "token")

    }
    
    override init() {
        super.init()
    }
    
    //将一个model的值转到另一个model上（存储在本地的）
    func giveDataToOtherAccount(newModel:NewAccount){
        
        for valueStr in self.getAllPropertys() {
            if let value = self.getValueOfProperty(property: valueStr){
                newModel.setValueOfProperty(property: valueStr, value: value)
            }
        }
        
    }
    
    //通过这个方法向单例添加密码
    private func setPassword(inputPassword:String){
        let password:NSString = inputPassword as NSString
        let encryptPWD =  password.md5()
        passwordEncrypt = encryptPWD!
    }
    //通过这个方法向单例添加助记词和密码
    func setEncyptHelpStringAndPassword(helpStr:String,password:String){
        setPassword(inputPassword: password)
        helpStringEncrypt = helpStr.encryt(password: passwordEncrypt)
    }
    //通过这个方法向单例添加私钥和密码
    func setEncyptPrivateKeyAndPassword(privateKey:String,password:String){
        setPassword(inputPassword: password)
        privateKeyEncrypt = privateKey.encryt(password: passwordEncrypt)
    }
    
    //获取助记词
    func getHelpString(password:String) ->String{
        let encryptPwd = (password as NSString).md5()
        let helpStr = helpStringEncrypt.dencryt(password: encryptPwd!)
        return helpStr
    }
    //获通过密码取出私钥
    func getPrivateKeyFromPwd(password:String) ->String{
        let encryptPwd = (password as NSString).md5()
        let privateKey = privateKeyEncrypt.dencryt(password: encryptPwd!)
        return privateKey
    }
    //获取私钥
    func getPrivateKey(password:String) ->String{
        let helpStr = self.getHelpString(password: password)
        if helpStr == "" {
            let privateKey = self.getPrivateKeyFromPwd(password: password)
            if (privateKey == ""){
                return ""
            }
            return privateKey
        }
        let secreatKet = Bridge.getAddressAndPrivateKey(withHelp: helpStr)
        var key = ""
        if secreatKet.last is String {
            key = (secreatKet.last as? String)!
        }
        return key
    }
    
    
    //检验密码是否正确
    func checkPassword(inputPassword:String) ->Bool{
        let encryptPwd = (inputPassword as NSString).md5()
        let helpStr = helpStringEncrypt.dencryt(password: encryptPwd!)
        let privateKey = privateKeyEncrypt.dencryt(password: encryptPwd!)
        if helpStr == "" {
            if (privateKey == ""){
                return false
            }
            return true
        }
        return true
    }
    
    //检验原密码是否正确，如果密码正确则更新密码
    func checkAndUpdatePassword(oldPassword:String,nPassword:String) ->Bool{
        let isEqual = checkPassword(inputPassword: oldPassword)
        if isEqual  {
            //内存中存储新密码，本地存储经新密码加密过后的助记词
            let helpStr = getHelpString(password: oldPassword)
            let privateKey = getPrivateKeyFromPwd(password: oldPassword)
            if (helpStr == ""){
                setEncyptPrivateKeyAndPassword(privateKey: privateKey, password: nPassword)
            }else{
                setEncyptHelpStringAndPassword(helpStr: helpStr, password: nPassword)
            }
            AccountManager.saveAccount(account: self)
        }
        return isEqual
    }
    
    //检验此账户是否存在(助记词和密码是否存在)
    func checkAccountIsExisted() -> Bool{
        var isExist = false
        if helpStringEncrypt.count>10&&address.count>6{
            isExist = true
        }
        return isExist
    }
    

    
}
//MARK: - AccountManager 获取、保存
class AccountManager: NSObject {
    
    static let new_path:String = NSHomeDirectory()+"/Documents/new_path.data"
    
    class func saveAccount(account:NewAccount){
        //每次存储的时候刷新本地account
        let shareAccount = NewAccount.shared()
        account.giveDataToOtherAccount(newModel: shareAccount)
        NSKeyedArchiver.archiveRootObject(account,toFile:new_path)
    }
    /// 获取账户
    class func getAccount() -> NewAccount{

        let account = NewAccount.shared()
        if account.address.count < 4 {
            if let savedModel:NewAccount = NSKeyedUnarchiver.unarchiveObject(withFile: new_path) as? NewAccount {
                savedModel.giveDataToOtherAccount(newModel: account)
            }
        }
        return account
    }
    
}

//MARK: - AccountManager 其他逻辑
extension AccountManager{
    //检测钱包信息（手机号）是否和登录的信息相同,如果不同，则清除并替换
    class func checkLocalWalletInfo(phone:String,token:String,address:String) ->Bool{
        let account = AccountManager.getAccount()
//        //先判断和本地存储手机号的是否相同
//        if (phone != account.phoneNum){
//            //手机号不相同,只保留现有手机号和token,需要导入钱包
//            clearNewAccountWithPhoneAndToken(token: token, phoneNum: phone,address:"" )
//            return false
//        }else if (address != AccountManager.getAccount().address) {
//            //地址不一致,只保留现有手机号和token,清除地址信息
//            clearNewAccountWithPhoneAndToken(token: token, phoneNum: phone,address: "")
//            return false
//        }else{
//            account.phoneNum = phone
//            account.token = token
//            AccountManager.saveAccount(account: account)
//            return true
//        }
        
        
        account.phoneNum = phone
        account.token = token
        AccountManager.saveAccount(account: account)
        return true
    }
    
    //更新（替换）本地钱包,仅保存手机号和token（这两个是h5传递来的数据）
    class func clearNewAccountWithPhoneAndToken(token:String,phoneNum:String,address:String){
        let newAccount = NewAccount()
        newAccount.token = token
        newAccount.phoneNum = phoneNum
        newAccount.address = address
        AccountManager.saveAccount(account: newAccount)
    }
}
