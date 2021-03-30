//
//  APIProviders.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/30/21.
//

import Foundation

class APIProviders {
    static var ExampleProvider: APIProvider = {
        let config = APIConfiguration(domain: "www.example.com", scheme: "http", port: 8080, apiPath: "api/v1", timeout: 120, willMostlyRequireAuth: false)
        return APIProvider(configuration: config, authHeaderHandler: nil, statusCodeHandler: nil)
    }()
    
    static var MainProvider: APIProvider = {
        /// Configure how you handle the authorization header here
        let authHeaderHandler: AuthHeaderHandler = { () -> String? in
            /**
             For instance, you have  a User object that has an accessible singleton to determine if they are logged in or not
             if let current = User.current,
                 let accessToken = current.accessToken{
                 return accessToken
             }
             */
            
            /// See LoginViewController for reference
            if let accessToken = UserDefaults.standard.string(forKey: "accessToken"){
                return accessToken
            }
            return nil
        }
        
        /// Configure how you handle the status codes here
        let statusCodeHandler: StatusCodeHandler = { (object) -> Bool in
            let statusCode = object.code
            let response = object.json
            if statusCode == 404{
                // handle 404
                let customError = Helpers.makeError(with: "The API returned empty request.")
                return object.decisionHandler(.error(error: customError))
            }
            else if statusCode == 401{
                // handle 401
                // for example, this code is token expired error
                // try to reload the tokens here then decide if should proceed or return an error
                return object.decisionHandler(.repeat)
            }
            else if statusCode == 403{
                // handle 403
                return object.decisionHandler(.complete)
            }
            else if statusCode == 500{
                // handle 500
                let customError = Helpers.makeError(with: "The API returned status code 500.")
                return object.decisionHandler(.error(error: customError))
            }
            return false
        }

        /// Apply the configurations here, and the custom domain and scheme
        let configuration = APIConfiguration(domain: "www.apidomain.com")
        return APIProvider(configuration: configuration,
                           authHeaderHandler: authHeaderHandler,
                           statusCodeHandler: statusCodeHandler)
    }()
}
