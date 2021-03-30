//
//  TextInputProtocol.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/30/21.
//

import UIKit

protocol TextInputProtocol {
    var inputText: String { get set }
}

extension TextInputProtocol{
    var trimmedText: String{
        return self.inputText.trimmed
    }
    
    var nullableTrimmmedText: String?{
        return self.trimmedText != "" ? self.trimmedText : nil
    }
    
    var parsedInteger: Int?{
        return Int(self.trimmedText)
    }
}

extension UITextField: TextInputProtocol{
    var inputText: String {
        get {
            return text ?? ""
        }
        set {
            text = newValue
        }
    }
}

extension UISearchBar: TextInputProtocol{
    var inputText: String {
        get {
            return text ?? ""
        }
        set {
            text = newValue
        }
    }
}

extension UITextView: TextInputProtocol{
    var inputText: String {
        get {
            return text
        }
        set {
            text = newValue
        }
    }
}
