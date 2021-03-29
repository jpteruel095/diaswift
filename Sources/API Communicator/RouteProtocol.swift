//
//  RouteProtocol.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Foundation
import Alamofire

public typealias WebMethod = HTTPMethod
public typealias AdditionalHeadersHandler = (() -> [HTTPHeader])
/// Common properties found in inheritted protocols or structs
public protocol RouteProtocol{
    // MARK: Route properties
    
    /// API Provider
    var provider: APIProvider { get }
    
    /**
     Path to endpoint (e.g., `api/v1/person`)
     Note: Paths must always start without the forward slash
     */
    var path: String { get }
    
    /// HTTP Method Used for the route
    var method: WebMethod { get }
    
    /// Some endpoints require parameter encoding to be specified. By default, `JSONEncoding.default` is used.
    var encoding: ParameterEncoding? { get }
    
    /// Specifies whether the route requires Authentication tokens
    var requiresAuth: Bool { get }
    
    /// Can customize the headers returned for specific routes. Some routes require more headers besides the regular `Authorization: Bearer <token>` Header
    var additionalHeadersHandler: AdditionalHeadersHandler? { get }
    
}

extension RouteProtocol{
    
    // MARK: Equating
    func isEqual(to route: RouteProtocol) -> Bool{
        route.provider == provider
            && route.path == path
            && route.method == method
            && route.url == url
    }
    
    /// Returns concantenated host and path
    var url: URL{
        let base = self.provider.configuration.basePath
        return URL(string: "\(base)\(path)")!
    }
}
