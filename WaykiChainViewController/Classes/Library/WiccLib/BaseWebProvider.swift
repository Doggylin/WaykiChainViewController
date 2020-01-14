//
//  BaseProvider.swift
//  CommApp
//
//  Created by sorath on 2018/10/10.
//  Copyright © 2018年 sorath. All rights reserved.
//

import UIKit

protocol BaseProviderProtocol{
    static func empower(jsbridge:WebViewJavascriptBridge)
    static func bridgeRegister(bridge:WebViewJavascriptBridge)
}

class BaseWebProvider: NSObject,BaseProviderProtocol {
    //授权与js交互
    class func empower(jsbridge:WebViewJavascriptBridge){
        bridgeRegister(bridge: jsbridge)
    }

}

//MARK: - 基础交互/ios端注册
extension BaseWebProvider {
    @objc class func bridgeRegister(bridge:WebViewJavascriptBridge){
        //获取信息
//        bridge.getAppLanguage()
        bridge.getAddress()
//        bridge.getAppChannelNo()
//        bridge.getUUID()
//        bridge.getAppVersion()
        bridge.getMnemonics()
        bridge.getPrivateKey()
        bridge.getTransferSignHex()
        bridge.getRegId()
        bridge.getContractSignHex()
        bridge.getActiviteHex()
        bridge.getPrivateKeyLoginMsg()
        //注册行为
//        bridge.notifyAppSaveImage()
//        bridge.notifyAppScan()
//        bridge.notifyAppShare()
//        bridge.notifyAppPlayVideo()
//        bridge.notifyAppPhotograph()
        bridge.notifyAppRevisePassword()
//        bridge.notifyAppSelectImagesOrPhotograph()
        bridge.notifyAppSaveWallet()
        bridge.notifyAppCheckMnemonics()
        bridge.notifyAppCreateNewAccount()
        bridge.notifyAppSaveRegId()
//        bridge.notifyAppDownloadImage()
        bridge.notifyAppCheckPrivateKey()
//        bridge.notifyAppjumpThirdUrl()
        bridge.changeLanguage()
//        bridge.notifyAppOpenPDF()
        bridge.notifyAppOpenUrl()
//        bridge.notifyAppUpdate()
        bridge.changeStatusTextColor()
        //第三方调用服务
        bridge.walletPluginContractInvoke()
        bridge.walletPluginContractIssue()
        bridge.walletPluginTransfer()
//        bridge.walletPluginNodeVote()
        bridge.getAddressInfo()
//        bridge.getStatusBarHeight()
        bridge.walletPluginUContractInvoke()
        bridge.walletPluginUCoinTransfer()
        bridge.deleteWallet()
        bridge.walletPluginAssetIssue()
        bridge.walletPluginAssetUpdate()
        bridge.getUCoinTransferSignHex()
        bridge.getUCoinContractSignHex()
        // 应用中心
//        bridge.jumpToApplication()
        bridge.walletPluginCdpStake()
        bridge.walletPluginCdpRedeem()
        bridge.walletPluginCdpLiquidate()
//        bridge.walletPluginDexLimit()
//        bridge.walletPluginDexMarket()
//        bridge.walletPluginDexCancelOrder()
        bridge.signMessage()
        bridge.getIdentity()
        bridge.identityautherror()
        bridge.getLanguage()
    }
    
    @objc class func bridgeRemove(bridge:WebViewJavascriptBridge){
        bridge.removeHandler("getAppLanguage")
        bridge.removeHandler("getAddress")
        bridge.removeHandler("getAppChannelNo")
        bridge.removeHandler("getUUID")
        bridge.removeHandler("getAppVersion")
        bridge.removeHandler("getMnemonics")
        bridge.removeHandler("getPrivateKey")
        bridge.removeHandler("getTransferSignHex")
        bridge.removeHandler("getRegId")
        bridge.removeHandler("getContractSignHex")
        bridge.removeHandler("getActiviteHex")
        bridge.removeHandler("getPrivateKeyLoginMsg")
        bridge.removeHandler("getStatusBarHeight")
        bridge.removeHandler("changeStatusTextColor")
        
        bridge.removeHandler("notifyAppUpdate")
        bridge.removeHandler("notifyAppOpenUrl")
        bridge.removeHandler("notifyAppOpenPDF")
        bridge.removeHandler("notifyAppjumpThirdUrl")
        bridge.removeHandler("notifyAppSaveImage")
        bridge.removeHandler("notifyAppScan")
        bridge.removeHandler("notifyAppShare")
        bridge.removeHandler("notifyAppPlayVideo")
        bridge.removeHandler("notifyAppPhotograph")
        bridge.removeHandler("notifyAppRevisePassword")
        bridge.removeHandler("notifyAppSelectImagesOrPhotograph")
        bridge.removeHandler("notifyAppSaveWallet")
        bridge.removeHandler("notifyAppCheckMnemonics")
        bridge.removeHandler("notifyAppCreateNewAccount")
        bridge.removeHandler("notifyAppSaveRegId")
        bridge.removeHandler("notifyAppDownloadImage")
        bridge.removeHandler("notifyAppCheckPrivateKey")
        bridge.removeHandler("changeLanguage")
        
        
        bridge.removeHandler("walletPluginContractInvoke")
        bridge.removeHandler("walletPluginContractIssue")
        bridge.removeHandler("walletPluginTransfer")
        bridge.removeHandler("walletPluginNodeVote")
        bridge.removeHandler("getAddressInfo")
        bridge.removeHandler("jumpToApplication")
        
        bridge.removeHandler("walletPluginUContractInvoke")
        bridge.removeHandler("walletPluginUCoinTransfer")
        bridge.removeHandler("deleteWallet")
        bridge.removeHandler("walletPluginAssetUpdate")
        bridge.removeHandler("walletPluginAssetIssue")
        bridge.removeHandler("getUCoinTransferSignHex")
        bridge.removeHandler("getUCoinContractSignHex")
        bridge.removeHandler("walletPluginCdpStake")
        bridge.removeHandler("walletPluginCdpRedeem")
        bridge.removeHandler("walletPluginCdpLiquidate")
        bridge.removeHandler("walletPluginDexLimit")
        bridge.removeHandler("walletPluginDexMarket")
        bridge.removeHandler("walletPluginDexCancelOrder")
        bridge.removeHandler("signMessage")
        bridge.removeHandler("getIdentity")
        bridge.removeHandler("identityautherror")
        bridge.removeHandler("routeJumpTo")
        bridge.removeHandler("getLanguage")
    }
    
}
