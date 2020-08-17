//
//  APIResponse.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 25/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

struct APIResponse: Codable
{
    let response: APIData
    let status: APIStatus
    
    private enum CodingKeys: String, CodingKey
    {
        case response = "response"
        case status = "status"
    }
}
