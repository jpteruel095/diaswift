//
//  EndpointProtocol+Getters.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Alamofire

extension EndpointProtocol{
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
}
