//
//  String.swift
//  WaykiApp
//
//  Created by louis and shuhao on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

extension String {
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }

    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    /** 语言本地化 */
    var local: String {
        return LocalizationTool.shareInstance.valueWithKey(key: self)
    }
    
    var replaceJson: String {
        return self.replacingOccurrences(of: "\"{", with: "{")
            .replacingOccurrences(of: "}\"", with: "}")
    }
    
    var length: Int {
        return self.count
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    /** 去除字符串两端的空白字符 */
    var trimming: String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    
    func indexOf(_ target: Character) -> Int? {
        return self.index(of: target)?.encodedOffset
    }
    
    func subString(to: Int) -> String {
        let endIndex = String.Index.init(encodedOffset: to)
        let subStr = self[self.startIndex..<endIndex]
        return String(subStr)
    }
    
    func subString(from: Int) -> String {
        let startIndex = String.Index.init(encodedOffset: from)
        let subStr = self[startIndex..<self.endIndex]
        return String(subStr)
    }
    
    func subString(start: Int, end: Int) -> String {
        let startIndex = String.Index.init(encodedOffset: start)
        let endIndex = String.Index.init(encodedOffset: end)
        return String(self[startIndex..<endIndex])
    }
    
    func subString(range: Range<String.Index>) -> String {
        return String(self[range.lowerBound..<range.upperBound])
    }
    
    /** 移除小数点后多余的零 如果为0 则显示0*/
    func removeEndZeros() ->String {
        if self.count == 0 {
            return self
        }
 
        let numbers = self.split(separator: ".")
        if numbers.count == 1 {
            return String(numbers[0])
        }
        
        var fontString = numbers[0]
        var backString = numbers[1]
        for char in backString.reversed() {
            if char == "0"  {
                backString.removeLast()
            }else{
                break
            }
        }
        if backString.count>0{
            fontString.append(contentsOf: ".")
            for char in backString {
                fontString.append(char)
            }
        }

        return String(fontString)
    }
    
    
    func toFloat()-> Float {
        var cgFloat: Float = 0
        if let doubleValue = Double(self){
            cgFloat = Float(doubleValue)
        }
        return cgFloat
    }
    
    func toInt()-> Int {
        var int: Int = 0
        if let doubleValue = Int(self) {
            int = Int(doubleValue)
        }
        return int
    }
    
    func toDouble()-> Double {
        var cDouble: Double = 0
        if let doubleValue = Double(self) {
            cDouble = Double(doubleValue)
        }
        return cDouble
    }
    
    func formartInputMoney(inputMoney:String,inputCharacter:String) -> Bool {
        let characters = ".0123456789"
        if (characters.range(of: inputCharacter) != nil)||(inputCharacter == "") {
            if (inputMoney.contains("."))&&(inputCharacter.contains(".")) {
                return false
            }
            return true
        }else{
            return false
        }
        
    }
    
    
    
    func encryt(password:String)->String{
        return SecurityUtil.encryptAESData(self, passWord: password)
    }
    
    func dencryt(password:String)->String{
        return SecurityUtil.decryptAESData(self, passWord: password)
    }
    
    //转json
    static func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    ///获取字符串高度
    func getLableHeigh(font:UIFont,width:CGFloat) -> CGFloat {
        
        let size = CGSize.init(width: width, height:  CGFloat(MAXFLOAT))
        
        let dic = [NSAttributedString.Key.font:font] 
        
        let strSize = self.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: dic, context:nil).size
        
        return ceil(strSize.height) + 1
    }
    ///获取字符串的宽度
    func getLableWidth(font:UIFont,height:CGFloat) -> CGFloat {
        
        let size = CGSize.init(width: CGFloat(MAXFLOAT), height: height)
        
        let dic = [NSAttributedString.Key.font:font]
        
        let cString = self.cString(using: String.Encoding.utf8)
        let str = String.init(cString: cString!, encoding: String.Encoding.utf8)
        let strSize = str?.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        return strSize?.width ?? 0
    }
    

}
extension Double {
    
    /// Rounds the double to decimal places value
    
    func roundTo(places:Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
        
    }
    
}
