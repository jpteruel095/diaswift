//
//  EndpointProtocol.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import Alamofire
import SwiftyJSON

/// Endpoint Protocol, extends RouteProtocol with additional functions
public protocol EndpointProtocol: RouteProtocol{
    // MARK: Associated Types
    
    /// Response type - Default: Swift Dictionary. Can also be [Any]
    associatedtype ResponseType = [String: Any]
    
    /// Parameter type - Default: DefaultParameter
    associatedtype ParameterType: ParameterProtocol = DefaultParameter
    
    // MARK: Type Aliases
    /// JSON Result with Error
    typealias JSONResult = Result<JSON, Error>
    
    /// Closure for single object result
    typealias SingleResultClosure = (Result<ResponseType, Error>) -> Void
    
    /// Closure for multiple objects result
    typealias MultipleResultClosure = (Result<[ResponseType], Error>) -> Void
    
    /// Sort Handler
    typealias SortHandler = ((ResponseType, ResponseType) throws -> Bool)
    
    // MARK: Properties
    /// Parameters to be used
    var parameters: ParameterType? { get }
    
    /// Nesting keys, depending on the structure of the data. Used to cast objects to corresponding models, if the base fields are not required
    var nestedKeys: [String] { get }
    
    /// Handler to sort data
    var sortHandler: SortHandler? { get }
    
    // MARK: Logging
    /// Disables logging of request headers and parameters
    var disablesDetailedRequestLogging: Bool { get }
    /// Disables logging of response data
    var disablesDetailedResponseLogging: Bool { get }
    
    // MARK: Debugging
    /**
     When adding to a struct or object, if you want this to be easily assigned, just use { _ in }.
     e.g.
     var debugRequest: DebugHandler = { _ in }
     var debugResponse: DebugHandler = { _ in }
     */
    var debugRequest: (Self) -> Void { get }
    var debugResponse: (JSONResult) -> Void { get }
}
