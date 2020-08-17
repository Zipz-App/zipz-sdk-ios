//
//  Helper.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 22/07/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

func stringFrom(date: Date) -> String {
    
    return formatter().string(from: date)
}

func dateFrom(string: String) -> Date? {
    
    return formatter().date(from: string)
}

fileprivate func formatter() -> DateFormatter
{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = TimeZone.autoupdatingCurrent
    return formatter
}
