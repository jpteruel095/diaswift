//
//  DoubleExt.swift
//  Google Drive Practice
//
//  Created by John Patrick Teruel on 1/20/21.
//

import Foundation

extension Double{
    func toInt(toCeil: Bool = false) -> Int{
        if toCeil {
            return Int( ceil(self) )
        }
        return Int(self)
    }
    
    func round(nearest: Double = 100) -> Double {
        let n = 1/nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }

    func floor(nearest: Double) -> Double {
        let intDiv = Double(Int(self / nearest))
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
