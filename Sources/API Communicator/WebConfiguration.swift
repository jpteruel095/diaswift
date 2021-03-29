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
    /// Pauses (same as returning to true
    case pause
}

/// Web pre-configuration
open class WebConfiguration{
    // MARK: Singletons
    
    /// Global shared singleton
    public static var shared = WebConfiguration(defaults: WebConfigurationDefaults(),
                                                authHeaderHandler: nil,
                                                statusCodeHandler: nil)
    /// Configures the default domain, scheme,
    public class func configure(domain: String,
                                scheme: String = "http",
                                timeout: Double? = nil,
                                authHeaderHandler: AuthHeaderHandler?,
                                statusCodeHandler: StatusCodeHandler?){
        let defaults = WebConfigurationDefaults(domain: domain,
                                                scheme: scheme,
                                                timeout: timeout)
        shared = WebConfiguration(defaults: defaults,
                                  authHeaderHandler: authHeaderHandler,
                                  statusCodeHandler: statusCodeHandler)
    }
    
    // MARK: Class instance properties
    
    /// Configuration Defaults
    var defaults: WebConfigurationDefaults
    /// Configured authentication header handler
    var authHeaderHandler: AuthHeaderHandler?
    /// Configured status code handler
    var statusCodeHandler: StatusCodeHandler?
    
    /// Initializer
    init(defaults: WebConfigurationDefaults,
         authHeaderHandler: AuthHeaderHandler?,
         statusCodeHandler: StatusCodeHandler?) {
        self.defaults = defaults
        self.authHeaderHandler = authHeaderHandler
        self.statusCodeHandler = statusCodeHandler
    }
}

/// Web Configuration Defaults
public struct WebConfigurationDefaults {
    var domain = "www.example.com"
    var scheme = "http"
    var apiPath: String?
    var timeout: Double?
    public var host: String{
        guard let path = apiPath else{
            return "\(scheme)://\(domain)/"
        }
        return "\(scheme)://\(domain)/\(path)/"
    }
}

