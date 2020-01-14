//
//  JSON.swift
//  CommApp
//
//  Created by louis on 2019/3/29.
//  Copyright © 2019 sorath. All rights reserved.
//


import UIKit

extension JSON {
    
    func dic() -> [String: Any] {
        let jsonData:Data = self.description.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! [String: Any]
        }
        return Dictionary()
    }
    
}
