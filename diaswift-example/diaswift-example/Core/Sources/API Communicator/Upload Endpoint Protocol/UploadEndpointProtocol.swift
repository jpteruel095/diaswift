//
//  UploadEndpointProtocol.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/30/21.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
 Upload Endpoint Protocol. Pretty similar to the regular EndpointProtocol, but has additional methods on its extension.
 */
public protocol UploadEndpointProtocol: EndpointProtocol{
    /// Parameter type - Default: DefaultParameter
    associatedtype ParameterType: UploadParameterProtocol = DefaultParameter
}

public protocol UploadParameterProtocol: ParameterProtocol{
    
}

extension UploadParameterProtocol{
    func addToFormData(_ formData: MultipartFormData){
        guard let parameters = getParameters() else {
            return
        }
        for (key, value) in parameters {
            if let array = value as? [Any]{
                self.addArrayToFormData(formData,
                                        key: key,
                                        array: array)
            }else if let dict = value as? [String: Any]{
                self.addDictToFormData(formData,
                                       key: key,
                                       dictionary: dict)
            }else{
                if let value = JSON(value).rawString(),
                    let data = value.data(using: .utf8){
                    formData.append(data, withName: key)
                }
            }
        }
    }
    
    /// Method used to append dictionary on form data, while considering nested objects.
    private func addDictToFormData(_ formData: MultipartFormData, key: String, dictionary: [String: Any]){
        for (dictKey, dictValue) in dictionary{
            let newKey = "\(key)[\(dictKey)]"
            if let itemArray = dictValue as? [Any] {
                addArrayToFormData(formData, key: newKey, array: itemArray)
            }else if let itemDict = dictValue as? [String: Any]{
                addDictToFormData(formData, key: newKey, dictionary: itemDict)
            }else{
                if let string = JSON(dictValue).rawString(),
                    let data = string.data(using: .utf8){
                    formData.append(data,
                                    withName: newKey)
                }
            }
        }
    }
    
    /// Method used to append arrays on form data, while considering nested objects.
    private func addArrayToFormData(_ formData: MultipartFormData, key: String, array: [Any]){
        for item in array {
            let newKey = "\(key)[]"
            if let itemArray = item as? [Any] {
                addArrayToFormData(formData, key: newKey, array: itemArray)
            }else if let itemDict = item as? [String: Any]{
                addDictToFormData(formData, key: newKey, dictionary: itemDict)
            }else{
                if let string = JSON(item).rawString(),
                    let data = string.data(using: .utf8){
                    formData.append(data,
                                    withName: newKey)
                }
            }
        }
    }
}
