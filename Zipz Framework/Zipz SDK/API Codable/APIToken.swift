//
//  APIToken.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 15/05/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

struct APIToken: Codable
{
    let token: String
    let showRegistration: Bool
    
    private enum CodingKeys: String, CodingKey
    {
        case token
        case showRegistration = "show_registration_profile"
    }
}

extension APIToken
{
    func save()
    {
        debugLog("💾💾💾 Saving token: \(self)")
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey:"APIToken")
        UserDefaults.standard.synchronize()
    }
    
    public static func read() -> APIToken?
    {
        if let data = UserDefaults.standard.value(forKey:"APIToken") as? Data {
            
            return try? PropertyListDecoder().decode(APIToken.self, from: data)
        }
        
        return nil
    }
    
    public static func remove()
    {
           UserDefaults.standard.removeObject(forKey: "APIToken")
           UserDefaults.standard.synchronize()
    }
}
