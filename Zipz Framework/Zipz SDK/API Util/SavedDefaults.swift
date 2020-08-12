//
//  SavedDefaults.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 22/07/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation


struct SavedDefaults
{
    static func getLastCallTime(for key: String) -> String? {
        
        let datetime = UserDefaults().value(forKey: key) as? String
        debugLog("📋 READ datetime call for: \(key)")
        return datetime
    }
    
    static func setLastCallTime(for key: String)
    {
        let stringDate = stringFrom(date: Date())
        UserDefaults().set(stringDate, forKey: key)
        UserDefaults().synchronize()
        
        debugLog("💾 SAVED datetime call for: \(key)")
    }
}
