//
//  Extensions.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import SwiftyJSON

extension Dictionary{
    func toJSONString() -> String{
        if let jsonString = JSON(self).rawString(){
            return jsonString
        }else{
            return "{}"
        }
    }
    
    func toJSON() -> JSON{
        return JSON(self)
    }
}
