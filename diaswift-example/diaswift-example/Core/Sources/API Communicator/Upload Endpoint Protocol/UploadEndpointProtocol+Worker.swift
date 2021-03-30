//
//  UploadEndpointProtocol+Worker.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/30/21.
//

import Foundation
import Alamofire
import SwiftyJSON

extension UploadEndpointProtocol{
    /**
     Calls the request for the specified Endpoint
     - parameters:
        - fileRequests: List of file request to be uploaded.
        - progressCallback: Callback that returns the progress of the current request.
        - completion: Callback for the response of the request.
     */
    func requestArrayWithFiles(_ fileRequests: [UploadFileRequest],
                               progress progressCallback:((Progress) -> Void)? = nil,
                               completion: MultipleResultClosure? = nil)
    {
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
        
        //Starts executing the request in hear
        let _ = AF.upload(multipartFormData: { (formData) in
            fileRequests.forEach { (request) in
                formData.append(request.data,
                                withName: request.parameterkey,
                                fileName: request.filename,
                                mimeType: request.mimetype)
            }
            // import parameters
            if let parameters = parameters{
                parameters.addToFormData(formData)
            }
        }, to: url,
           method: method,
           headers: headers,
        requestModifier: requestModifier).uploadProgress(closure: { (progress) in
            print("progress: \(progress.fractionCompleted)")
            if let progressCallback = progressCallback{
                DispatchQueue.main.async {
                    progressCallback(progress)
                }
            }
           }).responseJSON { (response) in
            self.handleResponse(response: response,
                                progressCallback: progressCallback,
                                completion: completion)
        }
    }
}
