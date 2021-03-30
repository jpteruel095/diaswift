//
//  LoginEndpoint.swift
//  rgmlib-example
//
//  Created by John Patrick Teruel on 1/15/21.
//

import Foundation
import SwiftyJSON

/// straightforward login endpoint with JSON type
struct LoginEndpoint: EndpointProtocol, ParameterProtocol{
    /// Specify the resulting model type. You can use the default JSON from SwiftyJson
    typealias ResponseType = JSON
    
    let provider: APIProvider = APIProviders.MainProvider
    /// Specify path to route. The following example would call: `http://www.example.com/api/login`
    let path: String = "api/login"
    let method: WebMethod = .post // usually, login endpoints are using POST
    /// Specify if the endpoint requires authorization.
    let requiresAuth: Bool = false // so user can login without a need of tokens, as users need to get tokens using this endpoint
    
    /// Parameters here
    var username: String
    var password: String
}
