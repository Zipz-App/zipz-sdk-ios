//
//  APIendpoint.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 25/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

public enum AuthAPI
{
    case login(parameters: [String:Any])
    case register(parameters: [String:Any])
    case advertising(id: String)
}

extension AuthAPI: EndpointProtocol
{
    var method: HTTPMethod { return .post }
    var headers: HTTPHeaders? { return nil }
    
    var environmentBaseURL : String
    {
        switch APIManager.environment
        {
        case .production: return "\(APIManager.productionBase)\(APIManager.verison)"
        case .staging: return ""
        case .development: return "\(APIManager.developmentBase)\(APIManager.verison)"
        }
    }
    
    var baseURL: URL
    {
        guard let url = URL(string: environmentBaseURL) else {
            
            fatalError("Base URL could not be configured.")
        }
        return url
    }
    
   
    var path: String
    {
        switch self
        {
        case .login:
            return "/init"
        case .register:
            return "/registration"
        case .advertising:
            return "/advertising_id"
        }
    }
    
    var task: HTTPTask
    {
        switch self
        {
        case .login(let parameters):
            return .requestParameters(bodyParameters: parameters)
        case .register(let parameters):
            return .requestParameters(bodyParameters: parameters)
        case .advertising(let id):
            let parameters: [String:Any] = ["advertising_id" : id]
            return .requestParameters(bodyParameters: parameters)
        }
    }
}
