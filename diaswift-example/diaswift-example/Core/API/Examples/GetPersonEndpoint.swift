//
//  GetPersonEndpoint.swift
//  rgmlib-example
//
//  Created by John Patrick Teruel on 1/7/21.
//

import Foundation
import SwiftyJSON

struct GetPersonEndpoint: EndpointProtocol, ParameterProtocol{
    
    /// Specify the resulting model type. You can use the default JSON from SwiftyJson
    typealias ResponseType = JSON
    
    let provider: APIProvider = APIProviders.ExampleProvider
    /// Specify path to route. The following example would call: `http://www.example.com/api/person`
    let path: String = "api/person"
    
    /// Specify if the endpoint requires authorization.
    let requiresAuth: Bool = false
    
    var debugRequest: (GetPersonEndpoint) -> Void = { _ in }
    var debugResponse: (JSONResult) -> Void = { _ in }
}
