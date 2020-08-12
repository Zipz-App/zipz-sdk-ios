//
//  Hours.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 11/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

struct Hours: Codable
{
    var mon: String?
    var tue: String?
    var wed: String?
    var thu: String?
    var fri: String?
    var sat: String?
    var sun: String?
    
    private enum CodingKeys: String, CodingKey  {
        case mon, tue, wed, thu, fri, sat, sun
    }
    
    public func encode(to encoder: Encoder) throws {
        var _ = encoder.container(keyedBy: CodingKeys.self)
    }
}
