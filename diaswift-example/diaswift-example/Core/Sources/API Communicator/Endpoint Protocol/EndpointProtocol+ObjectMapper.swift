//
//  EndpointProtocol+ObjectMapper.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/30/21.
//

import SwiftyJSON
import ObjectMapper

public extension EndpointProtocol where ResponseType: Any & Mappable{
    func serializeResponse(with object: Any, completion: MultipleResultClosure? = nil){
        var json: JSON? = JSON(object)
        
        nestedKeys.forEach { (key) in
            json = json?.dictionary?[key]
        }
        
        if let dictionaryObject = json?.dictionaryObject{
            guard let object = ResponseType(JSON: dictionaryObject) else{
                let error = Helpers.makeError(with: "Could not parse object to \(ResponseType.self)")
                completion?(.failure(error))
                return
            }
            completion?(.success([object]))
        }else if let objectArray = json?.array{
            var objects = objectArray.compactMap({ json -> ResponseType? in
                guard let rawObject = json.dictionaryObject else{
                    return nil
                }
                return ResponseType(JSON: rawObject)
            })
            if let sortHandler = self.sortHandler{
                try? objects.sort(by: sortHandler)
            }
            completion?(.success(objects))
        }else{
            let error = Helpers.makeTechnicalError()
            completion?(.failure(error))
        }
    }
}
