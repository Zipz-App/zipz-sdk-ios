//
//  HTTPService.swift
//  Networking
//
//  Created by Mirko Trkulja on 16/04/2018.
//  Copyright © 2018 Mirko Trkulja. All rights reserved.
//

import Foundation

// HTTPHeaders is just a typealias for a dictionary
public typealias HTTPHeaders = [String:String]

public enum HTTPMethod: String
{
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

public enum HTTPTask
{
    case request
    
    case requestParameters(bodyParameters: Parameters? = nil,
        urlParameters: Parameters? = nil)
    
    case requestParametersAndHeaders(bodyParameters: Parameters? = nil,
        urlParameters: Parameters? = nil,
        additionHeaders: HTTPHeaders? = nil)
    
    // TODO: - case download, upload... etc
}
