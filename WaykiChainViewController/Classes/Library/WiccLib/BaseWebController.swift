//
//  BaseWebController.swift
//  CommApp
//
//  Created by sorath on 2018/10/10.
//  Copyright © 2018年 sorath. All rights reserved.
//

import UIKit

class BaseWebController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{get { return.default}}
    var wkWebView: WKWebView = WKWebView.init()
//    var noNetWorkView:NoNetworkView?
    var showHUD: Bool = true
    var newWeb: Bool = false
    var networkStatus:Bool = false
    var networkConnectNum = 0
    var xbarView : UIView? = nil
    var bridge:WebViewJavascriptBridge?
    var provider:String = NSStringFromClass(BaseWebProvider.self)    //对应界面的提供者classname
    var url:String = ""
    var loadingView:UIView? = nil
    var viewAppearNum:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newWeb {
            addNewWKWebView()
        }else {
            addWKWebView()
        }
        

        wkWebView.frame = CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height())
        
        wkWebView.translatesAutoresizingMaskIntoConstraints = true
        
        wkWebView.scrollView.backgroundColor = UIColor.white
        view.backgroundColor = .white
        //设置bridge
        setupBridge()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewAppearNum = viewAppearNum + 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        RequestHandler.dismissHUD()
    }

    deinit {
        if bridge != nil{
            BaseWebProvider.bridgeRemove(bridge: bridge!)
        }
        wkWebView.scrollView.delegate = nil
    }
    
    func loadedNewWeb() {
        
    }
    func xbar(height:CGFloat){
        let xbar = UIImageView.init()
        xbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        xbar.image = UIImage.init(named: "xbg")
        xbar.contentMode = .top
        view.addSubview(xbar)
        xbarView = xbar
        xbarView?.alpha = 0
        
    }
    
}

//MARK: - WKNavigationDelegate/Create
extension BaseWebController:WKNavigationDelegate, UIScrollViewDelegate{
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingView?.removeFromSuperview()
        let errors = error as NSError
        if errors.code == NSURLErrorCancelled{
            return
        }
//        noNetWorkView?.show()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingView?.removeFromSuperview()
        let errors = error as NSError
        if errors.code == NSURLErrorCancelled{
            return
        }
//        noNetWorkView?.show()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       addLoadingView()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView?.removeFromSuperview()
//        noNetWorkView?.hidden()
        loadedNewWeb()
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust{
            let card = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,card)
        }
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        if wkWebView.url == nil{
            reloadURL(url: url)
        }else{
            wkWebView.reload()
        }
    }
    
    private func addNewWKWebView(){
        let preferences = WKPreferences.init()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration.init()
        configuration.allowsInlineMediaPlayback = true
        configuration.processPool = EKWWKProcessPool.sharedProcessPool
        wkWebView = WKWebView.init(frame: CGRect.zero, configuration: configuration)
        wkWebView.scrollView.isScrollEnabled = true
//        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.scrollView.bounces = false
        wkWebView.scrollView.bouncesZoom = false
        wkWebView.contentMode = .scaleToFill
        wkWebView.scrollView.showsVerticalScrollIndicator = false
        wkWebView.scrollView.showsHorizontalScrollIndicator = false
        createNotNetView()
        
        if #available(iOS 11.0, *) {
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }

    
        
    }
    ///添加缓冲页
    private func addLoadingView(){
        let v = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        v.backgroundColor = .white
        let bgImg = UIImageView.init(frame:CGRect(x: 0, y: 0, width: v.bounds.size.width, height: v.bounds.size.width * 2))
        bgImg.image = UIImage.init(named: "buffer")
        v.addSubview(bgImg)
        let loadingImg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        loadingImg.center = v.center
        loadingImg.image = UIImage.init(named: "loading")
        v.addSubview(loadingImg)
        view.addSubview(v)
        loadingView = v

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") // 让其在z轴旋转
        rotationAnimation.toValue = CGFloat.pi * 2 // 旋转角度
        rotationAnimation.duration = 0.8 // 旋转周期
//        rotationAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        rotationAnimation.isCumulative = true // 旋转累加角度
        rotationAnimation.repeatCount = 100000 // 旋转次数
        loadingImg.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    private func addWKWebView(){
        
        //2.使用创建的单例WKProcessPool
        let configuration = WKWebViewConfiguration.init()
        
        let userController = WKUserContentController.init()
        configuration.userContentController = userController
        
        //使用单例 解决locastorge 储存问题
        configuration.processPool = EKWWKProcessPool.sharedProcessPool
        configuration.allowsInlineMediaPlayback = true
        let preferences = WKPreferences.init()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        configuration.preferences.minimumFontSize = 9.0
        wkWebView = WKWebView.init(frame: CGRect.zero, configuration: configuration)
        wkWebView.scrollView.bounces = false
        wkWebView.scrollView.bouncesZoom = false
        wkWebView.scrollView.showsVerticalScrollIndicator = false
        wkWebView.scrollView.showsHorizontalScrollIndicator = false
        createNotNetView()
        
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }

    }
    
    //无数据图配置
    private func createNotNetView(){
//        noNetWorkView = NoNetworkView.getNoNetworkView(frame: self.view.bounds)
//        noNetWorkView?.clickBlock = { [weak self] in
//            if self?.wkWebView.url == nil{
//                self?.reloadURL(url: (self?.url)!)
//                self?.wkWebView.reload()
//            }else{
//                self?.wkWebView.reload()
//            }
//        }
//        noNetWorkView?.hidden()
//        self.wkWebView.addSubview(noNetWorkView!)
    }

}


//MARK: - WKWebViewConfiger
extension BaseWebController {
    //设置与js交互的bridge和处理事件
    func setupBridge(){
        bridge = bridgeForWebView(wkWebView)
        //设置delegate
        bridge?.setWebViewDelegate(self)
        //将与h5交互的 事件交给Provider处理
        //判断是否有指定处理类
        if let proClass =  NSClassFromString(provider).self{
            if proClass is BaseWebProvider.Type{
                let pC = proClass as! BaseWebProvider.Type
                pC.empower(jsbridge: bridge!)
                return
            }
        }
        BaseWebProvider.empower(jsbridge: bridge!)
    }
    
    func bridgeForWebView(_ webView: Any) -> WebViewJavascriptBridge {
        let bridge = WebViewJavascriptBridge.init(webView)!
        //WebViewJavascriptBridge.enableLogging()
        //bridge.setWebViewDelegate(webView)
        return bridge
    }
    
    func reloadURL(url:String){
          if let uRL = URL(string: url) {
            wkWebView.load(URLRequest.init(url:uRL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 20))
            if wkWebView.superview != view{
                view.addSubview(wkWebView)
            }
        }
    }
}

class NativeWebViewScrollViewDelegate: NSObject, UIScrollViewDelegate {
    
    // MARK: - Shared delegate
    static var shared = NativeWebViewScrollViewDelegate()
    
    // MARK: - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
}

//MARK: - ProcessPool
//创建单例WKProcessPool
class EKWWKProcessPool: WKProcessPool {
    class var sharedProcessPool: EKWWKProcessPool {
        struct Static {
            static let instance: EKWWKProcessPool = EKWWKProcessPool()
        }
        
        return Static.instance
    }
}



