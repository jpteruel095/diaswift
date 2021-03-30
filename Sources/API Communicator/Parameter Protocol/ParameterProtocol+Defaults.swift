//
//  ParameterProtocol+Defaults.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Foundation

public extension ParameterProtocol{
    // MARK: Request Parameters Extension
    var excludedKeys: [String] { [] }
    
    var includedKeys: [String]? { nil }
    
    var additionalParameters: OptionalParameters? { nil }
    
    var finalExcludedKeys: [String]{
        var keys = self.defaultPropertyKeys
        keys.append(contentsOf: excludedKeys)
        return keys
    }
    
    /// Default ParameterProtocol Keys
    var defaultPropertyKeys: [String] {
        [
            "excludedKeys",
            "includedKeys",
            "additionalParameters",
        ]
    }
}
