//
//  LocalizationTool.swift
//  CommApp
//
//  Created by lcl on 2019/5/24.
//  Copyright © 2019 sorath. All rights reserved.
//

import UIKit

class LocalizationTool: NSObject {
    static let shareInstance = LocalizationTool()
    
    let def = UserDefaults.standard
    var bundle : Bundle?
    
    func valueWithKey(key: String!) -> String {
        let bundle = LocalizationTool.shareInstance.bundle
        let str = bundle?.localizedString(forKey: key, value: nil, table:nil)
        if let s = str {
            return s
        }
        return ""
    }
    
    func setLanguage(langeuage:String) {
        var str=langeuage
        if langeuage==""{
            
            let languages:[String]=UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
            let str2:String=languages[0]
//            print("=========>",str2)
//            let str2 = NSLocale.preferredLanguages.first
            if (str2.contains(find: "zh")){
                str="zh-Hans"
            }else{
                str="en"
            }
            
        }
        print(str)
        UserDefaults.standard.set(str, forKey: "langeuage")
        UserDefaults.standard.synchronize()
        let path = Bundle.main.path(forResource:str , ofType: "lproj")
        bundle = Bundle(path: path!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
        
        
    }
}

