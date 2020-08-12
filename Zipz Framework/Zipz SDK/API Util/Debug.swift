//
//  Debug.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 15/05/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import UIKit

enum LogType
{
    case log
    case error
    case detail
}

func debugLog(_ item: Any, logType: LogType = .log, file: NSString = #file, line: Int = #line, function: String = #function)
{
    #if DEBUG
        switch logType {
        case .log:
            print("Zipz -- \(item)")
        case .error:
            print("Zipz Error -- \(item) in \(file.lastPathComponent)(\(line)) -> \(function)")
        case .detail:
            print("Zipz -- \(file.lastPathComponent)(\(line)):\(function): \(item)")
        }
    #endif
}
