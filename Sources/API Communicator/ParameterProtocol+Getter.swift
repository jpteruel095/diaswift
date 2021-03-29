//
//  ParameterProtocol+Getter.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Alamofire

extension ParameterProtocol{
    /// Returns the default Parameters with keys based from the variable names
    func getParameters() -> Parameters?{
        var parameters: Parameters = [:]
        
        var listPropertiesWithValues: ((Mirror?) -> Void)!
        listPropertiesWithValues = { reflect in
            let mirror = reflect ?? Mirror(reflecting: self)
            if mirror.superclassMirror != nil {
                listPropertiesWithValues(mirror.superclassMirror)
            }

            for (_, attr) in mirror.children.enumerated() {
                // gets the property label from the class/struct
                guard let property_name = attr.label else{
                    continue
                }
                
                // checks if there are only included keys and the key is included
                if let included = includedKeys,
                   !included.contains(property_name){
                    continue
                }
                
                // checks if keys is not excluded
                guard !self.finalExcludedKeys.contains(property_name),
                      let val = self.getValue(unknownValue: attr.value) else{
                    continue
                }
                
                // inserts the parameter
                parameters[property_name] = val
            }
        }
        listPropertiesWithValues(nil)
        
        if let additional = additionalParameters{
            let compact = additional.compactMapValues({$0})
            parameters.merge(compact) { _, new in new }
        }
        
        return parameters
    }
    
    /// Assesses the property value to avoid complications
    private func getValue(unknownValue: Any) -> Any? {

        let value = Mirror(reflecting: unknownValue)
        if value.displayStyle != .optional || value.children.count != 0 {
            if value.displayStyle == .optional{
                let type = value.subjectType
                if type == String?.self{
                    return unknownValue as? String
                }else if type == Int?.self{
                    return unknownValue as? Int
                }else if type == Double?.self{
                    return unknownValue as? Double
                }else if type == Float?.self{
                    return unknownValue as? Float
                }
            }
            return unknownValue
        } else {
            return nil
        }
    }
}
