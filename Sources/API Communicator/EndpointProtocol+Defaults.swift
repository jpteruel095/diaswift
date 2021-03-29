//
//  EndpointProtocol+Defaults.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Alamofire

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
    
    /// Nil parameters
    var parameters: ParameterType? { nil }
    
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
    
    /// Defaults debugging to nil
    var debugRequest: (Self) -> Void {
        { request in
            var debugText = """
            Request URL: \(request.url.absoluteString)
            Method: \(request.method.rawValue)
            """
            
            guard !disablesDetailedRequestLogging else{
                self.debugPrint(debugText)
                return
            }
            
            if let headers = request.headers,
               headers.count > 0{
                debugText.append("\nHeaders: \(headers.dictionary.toJSONString())")
            }else{
                debugText.append("\nHeaders: empty")
            }
            
            if let parameters = parameters?.getParameters(),
               parameters.keys.count > 0{
                debugText.append("\nParameters: \(parameters.toJSONString())")
            }else{
                debugText.append("\nParameters: empty")
            }
            
            self.debugPrint(debugText)
        }
    }
    
    var debugResponse: (JSONResult) -> Void {
        return { result in
            var debugText = """
            Response for URL: \(url.absoluteString)
            Method: \(method.rawValue)
            """
            guard !disablesDetailedResponseLogging else{
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
            
            self.debugPrint(debugText)
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
