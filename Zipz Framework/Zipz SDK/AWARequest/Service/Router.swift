//
//  Router.swift
//  Networking
//
//  Created by Mirko Trkulja on 16/04/2018.
//  Copyright © 2018 Mirko Trkulja. All rights reserved.
//

import Foundation
import UIKit

class Router <Endpoint: EndpointProtocol>: NetworkRouter
{
    private var task: URLSessionTask?
    
    // MARK: - Public Methods
    func request(_ route: Endpoint, completion: @escaping NetworkRouterCompletion)
    {
        let session = URLSession.shared
        
        do {
            let request = try self.buildRequest(from: route)
            
        #if DEBUG
            NetworkLogger.log(request: request)
        #endif
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                completion(data, response, error)
            })
        }
        catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>
    {
        switch response.statusCode
        {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    func cancel()
    {
        self.task?.cancel()
    }
    
    // MARK: - Fileprivate Methods
    fileprivate func buildRequest(from route: Endpoint) throws -> URLRequest
    {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 5.0)
        request.httpMethod = route.method.rawValue
        
        do {
            switch route.task
            {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionHeaders):
                self.additionalHeaders(additionHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                
                // TODO: - case download, upload... etc
            }
            
            return request
        }
        catch  {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws
    {
        do
        {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        }
        catch  {
            throw error
        }
    }
    
    fileprivate func additionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest)
    {
        guard let headers = additionalHeaders else { return }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
