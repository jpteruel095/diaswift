//
//  AzureEndpoint.swift
//  rgmlib-example
//
//  Created by John Patrick Teruel on 2/3/21.
//

import Foundation
import SwiftyJSON

struct AzureEndpoint: EndpointProtocol, ParameterProtocol{
    /// Specify the resulting model type. You can use the default JSON from SwiftyJson
    typealias ResponseType = JSON
    
    let provider: APIProvider = AzureProviders.config1
    /// Specify path to route. The following example would call: `http://example1.azure.com/api/person`
    let path: String = "api/person"
    
    /// Specify if the endpoint requires authorization.
    let requiresAuth: Bool = false
    
    var debugRequest: (GetPersonEndpoint) -> Void = { _ in }
    var debugResponse: (JSONResult) -> Void = { _ in }
}

/// Global configurations
class AzureProviders{
    static var config1: APIProvider = {
        let defaults = APIConfiguration(domain: "example1.azure.com")
        return APIProvider(configuration: defaults,
                           authHeaderHandler: nil,
                           statusCodeHandler: nil)
    }()
    
    static var config2: APIProvider = {
        let defaults = APIConfiguration(domain: "example2.azure.com")
        return APIProvider(configuration: defaults,
                                authHeaderHandler: nil,
                                statusCodeHandler: nil)
    }()
    
    static var config3: APIProvider = {
        let defaults = APIConfiguration(domain: "example3.azure.com")
        return APIProvider(configuration: defaults,
                                authHeaderHandler: nil,
                                statusCodeHandler: nil)
    }()
}
