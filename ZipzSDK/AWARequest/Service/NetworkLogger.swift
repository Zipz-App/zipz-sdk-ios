//
//  NetworkLogger.swift
//  Networking
//
//  Created by Mirko Trkulja on 18/04/2018.
//  Copyright © 2018 Mirko Trkulja. All rights reserved.
//

import Foundation

class NetworkLogger
{
    static func log(request: URLRequest)
    {
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
    }
    
    static func debug(_ responseData: Data)
    {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
            print("DEBUG DATA: \(jsonData)")
        } catch {
            print("DEBUG ERROR: \(NetworkResponse.unableToDecode.rawValue)")
        }
    }
}
