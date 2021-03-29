//
//  EndpointProtocol+Interface.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Foundation
import Alamofire

public extension EndpointProtocol{
    /// Just a single request call. Usually used when logging without handling the result.
    func request(){
        requestArrayWithProgress()
    }
    
    /// Used to get single result without additional configuration.
    func requestSingle(completion: @escaping SingleResultClosure){
        requestArrayWithProgress(completion: { result in
            switch result{
            case .success(let models):
                guard let model = models.first else{
                    let error = Helpers.makeError(with: "Could not retrieve \(ResponseType.self) record")
                    completion(.failure(error))
                    return
                }
                completion(.success(model))
                break
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    /// Used to get multiple results without additional configuration.
    func requestMultiple(completion: @escaping MultipleResultClosure){
        self.requestArrayWithProgress(completion: completion)
    }
    
    /// Used to get single result while handling the progress.
    func requestSingleWithProgress(_ progressHandler:@escaping Request.ProgressHandler,
                                   completion: @escaping SingleResultClosure){
        requestArrayWithProgress(progressHandler, completion: { result in
            switch result{
            case .success(let models):
                guard let model = models.first else{
                    let error = Helpers.makeError(with: "Could not retrieve \(ResponseType.self) record")
                    completion(.failure(error))
                    return
                }
                completion(.success(model))
                break
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    /// Used to get multiple results while handling the progress.
    func requestMultipleWithProgress(_ progressCallback:@escaping Request.ProgressHandler, completion: @escaping MultipleResultClosure){
        self.requestArrayWithProgress(progressCallback, completion: completion)
    }
}
