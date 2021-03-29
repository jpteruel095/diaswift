//
//  EndpointProtocol.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Alamofire
import SwiftyJSON

/// Endpoint Protocol, extends RouteProtocol with additional functions
public protocol EndpointProtocol: RouteProtocol{
    // MARK: Associated Types
    
    /// Response type - Default: Swift Dictionary. Can also be [Any]
    associatedtype ResponseType = [String: Any]
    
    // MARK: Type Aliases
    /// JSON Result with Error
    typealias JSONResult = Result<JSON, Error>
    
    /// Closure for single object result
    typealias SingleResultClosure = (Result<ResponseType, Error>) -> Void
    
    /// Closure for multiple objects result
    typealias MultipleResultClosure = (Result<[ResponseType], Error>) -> Void
    
    /// Sort Handler
    typealias SortHandler = ((ResponseType, ResponseType) throws -> Bool)
    
    // MARK: Properties
    /// Nesting keys, depending on the structure of the data. Used to cast objects to corresponding models, if the base fields are not required
    var nestedKeys: [String] { get }
    
    /// Serialized response based on nested keys
    func serializeResponse(with object: Any, completion:MultipleResultClosure?)
    
    /// Handler to sort data
    var sortHandler: SortHandler? { get }
    
    // MARK: Logging
    /// Disables logging of request headers and parameters
    var disablesDetailedRequestLogging: Bool { get }
    /// Disables logging of response data
    var disablesDetailedResponseLogging: Bool { get }
    
    // MARK: Debugging
    /**
     When adding to a struct or object, if you want this to be easily assigned, just use { _ in }.
     e.g.
     var debugRequest: DebugHandler = { _ in }
     var debugResponse: DebugHandler = { _ in }
     */
    var debugRequest: (Self) -> Void { get }
    var debugResponse: (JSONResult) -> Void { get }
}

/// Endpoint protocol default values
public extension EndpointProtocol{
    // MARK: Route Extension
    
    /// Default method is GET
    var method: HTTPMethod { .get }
    
    /// Custom encoding if need to be provided. Nil by default
    var encoding: ParameterEncoding? { nil }
    
    /// Depends on the API configuration
    var requiresAuth: Bool { self.provider.configuration.willMostlyRequireAuth }
    
    /// Returns null for additional headers handler
    var additionalHeadersHandler: AdditionalHeadersHandler? { nil }
    
    /// Blank nested keys
    var nestedKeys: [String] { [] }
    
    /// Nil sort handler
    var sortHandler: SortHandler? { nil }
    
    /// Logs request by default
    var disablesDetailedRequestLogging: Bool { false }
    /// Logs response by default
    var disablesDetailedResponseLogging: Bool { false }
    
    /// Returns parameter encoding if specified or based on method
    var parameterEncoding: ParameterEncoding{
        if let encoding = self.encoding{
            return encoding
        }else{
            if self.method == .post{
                return JSONEncoding.default
            }else{
                return URLEncoding.default
            }
        }
    }
    
    /**
     Returns the headers for specific endpoints. If the endpoint is a guest endpoint and no token is saved,
     the header is null.
     */
    var headers: HTTPHeaders?{
        var headers = [HTTPHeader]()
        
        if requiresAuth{
            if let handler = self.provider.authHeaderHandler,
               let accessToken = handler(){
                headers.append(HTTPHeader(name: "Authorization",
                                          value: "Bearer \(accessToken)"))
            }else{
                return nil
            }
            
            if let closure = additionalHeadersHandler{
                let additionalHeaders = closure()
                if additionalHeaders.count > 0{
                    headers.append(contentsOf: additionalHeaders)
                }else{
                    return nil
                }
            }
        }
        
        return HTTPHeaders(headers)
    }
    
    /// Defaults debugging to nil
    var debugRequest: (Self) -> Void {
        { request in
            var debugText = """
            Request URL: \(request.url.absoluteString)
            Method: \(request.method.rawValue)
            """
            
            if let headers = request.headers,
               headers.count > 0{
                debugText.append("\nHeaders: \(headers.dictionary.toJSONString())")
            }else{
                debugText.append("\nHeaders: empty")
            }
            
//                if let parameters = parameters?.getParameters(),
//                   parameters.keys.count > 0{
//                    req.append("\nParameters: \(parameters.toJSONString())")
//                }else{
//                    req.append("\nParameters: empty")
//                }
        }
    }
    
    var debugResponse: (JSONResult) -> Void {
        return { result in
            var debugText = """
            Response for URL: \(url.absoluteString)
            Method: \(method.rawValue)
            """
            guard !disablesDetailedRequestLogging else{
                self.debugPrint(debugText)
                return
            }
            
            switch result {
            case .success(let json):
                if let rawString = json.rawString(){
                    debugText.append("\nJSON: \(rawString)")
                }else{
                    debugText.append("\nJSON (Object): \(json)")
                }
            case .failure(let error):
                debugText.append("\nJSON: empty")
                debugText.append("\nError: \(error.localizedDescription)")
            }
        }
    }
}

private extension EndpointProtocol{
    // MARK: Private Helpers
    func debugPrint(_ text: String){
        #if DEBUG
        print(text)
        #endif
    }
}

private extension Dictionary{
    func toJSONString() -> String{
        if let jsonString = JSON(self).rawString(){
            return jsonString
        }else{
            return "{}"
        }
    }
    
    func toJSON() -> JSON{
        return JSON(self)
    }
}
