//
//  FloatExt.swift
//  rgmlib-example
//
//  Created by John Patrick Teruel on 2/3/21.
//

import Foundation

extension Float {
    func toInt(toCeil: Bool = false) -> Int{
        if toCeil {
            return Int( ceil(self) )
        }
        return Int(self)
    }
    
    func round(nearest: Float = 100) -> Float {
        let n = 1/nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }

    func floor(nearest: Float) -> Float {
        let intDiv = Float(Int(self / nearest))
        return intDiv * nearest
    }
    
    var twoDigits: String {
        return String(format: "%.2f", self)
    }
    
    var clean2Digits: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
    
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
