//
//  RouteProtocol.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Alamofire

public typealias WebMethod = HTTPMethod
public typealias AdditionalHeadersHandler = (() -> [HTTPHeader])
/// Common properties found in inheritted protocols or structs
public protocol RouteProtocol{
    // MARK: Route properties
    
    /// Path to endpoint (e.g., `api/v1/person`)
    var path: String { get }
    
    /// HTTP Method Used for the route
    var method: WebMethod { get }
    
    /// Some endpoints require parameter encoding to be specified. By default, `JSONEncoding.default` is used.
    var encoding: ParameterEncoding? { get }
    
    /// Specifies whether the route requires Authentication tokens
    var requiresAuth: Bool { get }
    
    /// Can customize the headers returned for specific routes. Some routes require more headers besides the regular `Authorization: Bearer <token>` Header
    var additionalHeadersHandler: AdditionalHeadersHandler? { get }
    
    /// Web configuration
    var configuration: WebConfiguration { get }
}
