//
//  ParameterProtocol.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Alamofire

public typealias OptionalParameters = [String: Any?]
public protocol ParameterProtocol {
    
    /// Excluded keys to be ignored by the getParameters() function
    var excludedKeys: [String] { get }
    
    /// If specified, the only properties to be recognized by the getParameters() function
    var includedKeys: [String]? { get }
    
    /// If specified, the additional parameters to be merged by the getParameters() function
    var additionalParameters: OptionalParameters? { get }
    
    /// Not really required, mostly used on objects that conforms on both Endpoint Protocol and Parameter Protocol
    var finalExcludedKeys: [String]{ get }
}
