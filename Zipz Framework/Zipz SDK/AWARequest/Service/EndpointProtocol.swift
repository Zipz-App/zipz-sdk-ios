//
//  EndpointProtocol.swift
//  Networking
//
//  Created by Mirko Trkulja on 16/04/2018.
//  Copyright © 2018 Mirko Trkulja. All rights reserved.
//

import Foundation

protocol EndpointProtocol
{
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
