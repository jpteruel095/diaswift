//
//  UploadEndpointProtocol+Interface.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/30/21.
//

import Foundation

public extension UploadEndpointProtocol{
    /// Just a single request call. Usually used when logging without handling the result.
    func requestWithFiles(_ files: [UploadFileRequest]){
        requestArrayWithFiles(files)
    }
    
    /// Used to get single result without additional configuration.
    func requestSingleWithFiles(_ files: [UploadFileRequest], completion: @escaping SingleResultClosure){
        requestArrayWithFiles(files, completion: { result in
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
    func requestMultipleWithFiles(_ files: [UploadFileRequest], completion: @escaping MultipleResultClosure){
        self.requestArrayWithFiles(files, completion: completion)
    }
    
    /// Used to get single result while handling the progress.
    func requestSingleWithFilesAndProgress(_ files: [UploadFileRequest],
                                progress progressCallback:@escaping ((Progress) -> Void),
                                completion: @escaping SingleResultClosure){
        requestArrayWithFiles(files, progress: progressCallback, completion: { result in
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
    func requestMultipleWithFilesAndProgress(_ files: [UploadFileRequest],
                                  progress progressCallback:@escaping ((Progress) -> Void),
                                  completion: @escaping MultipleResultClosure){
        self.requestArrayWithFiles(files, progress: progressCallback, completion: completion)
    }
}
