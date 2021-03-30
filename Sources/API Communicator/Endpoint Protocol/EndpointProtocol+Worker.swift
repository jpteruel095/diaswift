//
//  EndpointProtocol+Handlers.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Foundation
import Alamofire
import SwiftyJSON

public extension EndpointProtocol{
    /**
     Calls the request for the specified Endpoint
     - parameters:
        - progressCallback: Callback that returns the progress of the current request.
        - completion: Callback for the response of the request.
     */
    func requestArrayWithProgress(_ progressCallback:Request.ProgressHandler? = nil, completion: MultipleResultClosure? = nil){
        //Check for headers available for the route
        //If the current request is a guest,
        // the header is not null
        guard let headers = headers else {
            if let completion = completion{
                let error = Helpers.makeError(with: "Unauthorized access. Token may have expired.")
                completion(.failure(error))
                //must implement a force logout functionality here
            }
            return
        }
        
        debugRequest(self)
        
        var requestModifier: Session.RequestModifier?
        requestModifier = { request in
            request.timeoutInterval = provider.configuration.timeout
        }
        //Starts executing the request in here
        AF.request(url,
                method: method,
                parameters: parameters?.getParameters(),
                encoding: parameterEncoding,
                headers: headers,
                requestModifier: requestModifier).downloadProgress(closure: { (progress) in
                //If the developer provided a callback for progress,
                // the callback will be called through here
                if let progressCallback = progressCallback{
                    print("progress: \(progress.fractionCompleted)")
                    DispatchQueue.main.async {
                        progressCallback(progress)
                    }
                }
        }).responseJSON(completionHandler: { (response) in
            self.handleResponse(response: response,
                                progressCallback: progressCallback,
                                completion: completion)
        })
    }
    
    /// Handles response
    func handleResponse(response: DataResponse<Any, AFError>,
                        progressCallback:((Progress) -> Void)? = nil,
                        completion: MultipleResultClosure? = nil)
    {
        //The developer can choose to log the result specifically.
        // If the logging of request was disabled by default,
        // The result will not be logged either.
        switch response.result {
        case .success(let object):
            debugResponse(.success(JSON(object)))
        case .failure(let error):
            debugResponse(.failure(error))
        }
        
        DispatchQueue.main.async {
            //error is not being thrown if the token is not expired from the backend
            //so better handle it in this block
            if let statusCode = response.response?.statusCode{
                print("Status \(statusCode)")
                
                var responseResultJSON: JSON?
                do{
                    responseResultJSON = JSON(try response.result.get())
                }catch{
                    completion?(.failure(error))
                    return
                }
                
                if statusCode != 200{
                    let decisionHandler: StatusCodeDecisionHandler = { decision in
                        switch decision {
                        case .proceed:
                            return false
                        case .complete:
                            completion?(.success([]))
                            return true
                        case .repeat:
                            self.requestArrayWithProgress(progressCallback,
                                                          completion: completion)
                            return true
                        case .error(let error):
                            completion?(.failure(error))
                            return true
                        case .pause:
                            return true
                        }
                    }
                    
                    let statusCodeObject = StatusCodeObject(route: self,
                                                            json: responseResultJSON,
                                                            code: statusCode,
                                                            decisionHandler: decisionHandler)
                    if let handler = self.provider.statusCodeHandler,
                       handler(statusCodeObject) == true{
                        return
                    }
                }
            }
            
            switch response.result{
            case .success(let json):
                self.serializeResponse(with: json, completion: completion)
                break
            case .failure(let error):
                print("An error occured while attempting to process the request")
                print(error)
                if error.localizedDescription.lowercased().contains("offline"){
                    let error = Helpers.makeOfflineError()
                    completion?(.failure(error))
                }else{
                    completion?(.failure(error))
                }
            }
        }
    }
    
    func serializeResponse(with object: Any, completion: MultipleResultClosure? = nil){
        print("Serialized regular")
        var json: JSON? = JSON(object)
        
        nestedKeys.forEach { (key) in
            json = json?.dictionary?[key]
        }
        
        if let arrayObject = json?.arrayObject{
            let array = arrayObject.compactMap({$0 as? ResponseType})
            completion?(.success(array))
        }else if let object = json?.object as? ResponseType{
            completion?(.success([object]))
        }else{
            let error = Helpers.makeTechnicalError()
            completion?(.failure(error))
        }
    }
}
