//
//  EndpointProtocol+SwiftyJSON.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/30/21.
//

import SwiftyJSON

public extension EndpointProtocol where ResponseType == JSON{
    func serializeResponse(with object: Any, completion: MultipleResultClosure? = nil){
        print("Serialized JSON")
        var json: JSON? = JSON(object)
        
        nestedKeys.forEach { (key) in
            json = json?.dictionary?[key]
        }
        
        if var array = json?.array{
            if let sortHandler = self.sortHandler{
                try? array.sort(by: sortHandler)
            }
            completion?(.success(array))
        }else if let json = json{
            completion?(.success([json]))
        }else{
            let error = Helpers.makeTechnicalError()
            completion?(.failure(error))
        }
    }
}
