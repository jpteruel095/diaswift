//
//  ParameterProtocol+EndpointProtocol.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Foundation

public extension ParameterProtocol where Self: EndpointProtocol{
    var defaultEndpointKeys: [String]{
        [
            /// Route Protocol
            "provider",
            "path",
            "method",
            "encoding",
            "requiresAuth",
            "additionalHeadersHandler",
            /// Endpoint Protocol
            "parameters",
            "nestedKeys",
            "sortHandler",
            "disablesDetailedRequestLogging",
            "disablesDetailedResponseLogging",
            "debugRequest",
            "debugResponse",
        ]
    }
    
    var finalExcludedKeys: [String]{
        var keys = self.defaultPropertyKeys
        keys.append(contentsOf: defaultEndpointKeys)
        keys.append(contentsOf: excludedKeys)
        return keys
    }
}

public struct DefaultParameter: ParameterProtocol{
    
}

