//
//  WebConfiguration.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Foundation
import SwiftyJSON

/// Auth Header Handler, mostly used for additional headers besides the regular OAuth
public typealias AuthHeaderHandler = () -> String?
/// Status Code
public typealias StatusCode = Int
/// Type alias for JSON
public typealias ResponseResultJSON = JSON

/// Status Code Handler
public typealias StatusCodeHandler = (StatusCodeObject) -> Bool
/// Status Code Decision Handler
public typealias StatusCodeDecisionHandler = (StatusCodeDecision) -> Bool

/// Status Code Object to be returned on the handler
public struct StatusCodeObject{
    /// The route being called
    var route: RouteProtocol
    /// The json response returned. Can be used to get specific response coming from the API.
    var json: ResponseResultJSON?
    /// The status code
    var code: StatusCode
    /// The decision handler to decide if the API should proceed when meeting certain conditions.
    var decisionHandler: StatusCodeDecisionHandler
}

/// Status Code Decision
public enum StatusCodeDecision {
    /// Proceeds to the actual response. Usually used for status code = 200
    case proceed
    /// Forces completion of the request without returning the response.
    case complete
    /// Repeats the same endpoint. Mostly used after doing a token refresh.
    case `repeat`
    /// Forces to return a customized error.
    case error(error: Error)
    /// Pauses (same as returning to true)
    case pause
}

/// Web pre-configuration
open class APIProvider: Equatable{
    // MARK: Class instance properties
    
    /// Configuration Defaults
    var configuration: APIConfiguration
    /// Configured authentication header handler
    var authHeaderHandler: AuthHeaderHandler?
    /// Configured status code handler
    var statusCodeHandler: StatusCodeHandler?
    
    // MARK: Initializer
    init(configuration: APIConfiguration,
         authHeaderHandler: AuthHeaderHandler?,
         statusCodeHandler: StatusCodeHandler?) {
        self.configuration = configuration
        self.authHeaderHandler = authHeaderHandler
        self.statusCodeHandler = statusCodeHandler
    }
    
    // MARK: Equatable Protocol
    public static func == (lhs: APIProvider, rhs: APIProvider) -> Bool {
        lhs.configuration == rhs.configuration
    }
}

/// API Configuration
public struct APIConfiguration: Equatable {
    /// Domain name used by the API
    var domain: String // e.g., www.example.com
    /// Scheme used by the API. Default is HTTPS
    var scheme = "https"
    /// Port used by the API. Optional.
    var port: Int?
    /// API Path mostly used by the API. Optional.
    var apiPath: String?
    /// Maximum timeout in seconds. Default is 60
    var timeout: Double = 60
    /// Will require auth on most of the endpoint (will be usable if there is an API that mostly don't require Authentication Headers)
    var willMostlyRequireAuth: Bool = true
    /// Base path for the URL
    public var basePath: String{
        /**
         Combines the scheme and domain name, without a forward slash at the end
         Example: https://www.example.com
         */
        var base = "\(scheme)://\(domain)"
        
        if let port = port{
            /**
             Combines the port, if specified.
             Example: http://www.example.com:2020
             */
            base.append(":\(port)")
        }
        
        if let path = apiPath{
            /**
             Combines the path, if specified. The appended string starts with a forward slash
             Example:
             If no port, http://www.example.com/api/v1
             else, http://www.example.com:2020/api/v1
             */
            base.append("/\(path)")
        }
        
        /**
         Combines the final base string with a forward slash at the end.
         Example:
         If no port, https://www.example.com/
         If with port, https://www.example.com:2020/
         If with API Path, https://www.example.com:2020/api/v1/
         */
        return "\(base)/"
    }
}

