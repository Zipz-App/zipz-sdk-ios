//
//  NetworkRouter.swift
//  Networking
//
//  Created by Mirko Trkulja on 16/04/2018.
//  Copyright © 2018 Mirko Trkulja. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?)->()

protocol NetworkRouter: class
{
    associatedtype Endpoint: EndpointProtocol
    func request(_ route: Endpoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

public enum NetworkEnvironment
{
    case development
    case production
    case staging
}

public enum NetworkResponse: String
{
    // TODO: - Write better and more helpful response error messages
    case success
    case authenticationError    = "You need to authenticate first."
    case badRequest             = "Bad request."
    case failed                 = "Network request failed."
    case outdated               = "The url you requested is outdated."
    case unableToDecode         = "We could not decode the response."
    case noData                 = "Response returned with no data to decode."
}

public enum Result<String>
{
    case success
    case failure(String)
}
