//
//  QRCard.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 31/07/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

class QRCard: NSObject, Codable
{
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
}
