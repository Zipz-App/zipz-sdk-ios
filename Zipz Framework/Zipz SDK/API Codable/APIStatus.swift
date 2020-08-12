//
//  APIStatus.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 25/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

struct APIStatus: Codable
{
    let success: Bool
    let code: Int
    let error: APIError?
    
    
    private enum CodingKeys: String, CodingKey
    {
        case success, error
        case code = "status_code"
    }
}
