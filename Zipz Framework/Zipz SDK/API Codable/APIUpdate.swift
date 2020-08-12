//
//  APIUpdate.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 09/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

struct APIUpdate: Codable
{
    let activeVersion: Int?
    let forceUpdate: Bool?
    let message: String?
    let update: Bool?
    
    private enum CodingKeys: String, CodingKey {
        
        case activeVersion, forceUpdate, message, update
    }
}
