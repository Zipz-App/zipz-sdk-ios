//
//  ParameterEncoding.swift
//  Networking
//
//  Created by Mirko Trkulja on 16/04/2018.
//  Copyright © 2018 Mirko Trkulja. All rights reserved.
//
import Foundation

// Parameters is just a typealias for a dictionary
public typealias Parameters = [String:Any]

public protocol ParameterEncoder
{
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error
{
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameters encoding failed."
    case missingURL = "URL is invalid or nil."
}
