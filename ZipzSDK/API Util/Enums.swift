//
//  Debug.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 15/05/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import UIKit

public enum ClusterType: String
{
    case shopping = "shopping"
    case brand = "brand"
    case category = "category"
    case campaign = "campaign"
}

public enum FetchType: Int
{
    case all
    case update
}

public enum LogType
{
    case log
    case error
    case detail
}

