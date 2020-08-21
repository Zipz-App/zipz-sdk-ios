//
//  APIError.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 25/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

struct APIError: Codable
{
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case message
    }
}
