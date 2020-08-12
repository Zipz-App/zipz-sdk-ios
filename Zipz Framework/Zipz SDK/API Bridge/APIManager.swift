//
//  APIManager.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 25/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony

public enum TapSource: String
{
    case organic = "organic"
    case notification = "notification"
    case deeplink = "deeplink"
}

class APIManager
{
    // MARK: - Static
    // Set environment endpoint and version
    static let productionBase: String = "https://api.zipz.app/sdk/"
    static let developmentBase: String = "https://api.zipz.dev/sdk/"
    static let verison: String = "v1"
    static let environment: NetworkEnvironment = .development
    
    // MARK: - Static Computed Properties
    static var id: String = {
        guard let id = APIManager.getProperty(for: "APP_ID") else {
            
            fatalError("Insert APP_ID string property into Info.plist")
        }
        return id
    }()
    
    static var secret: String = {
        guard let secret = APIManager.getProperty(for: "APP_SECRET") else {
            
            fatalError("Insert APP_SECRET string property into Info.plist")
        }
        return secret
    }()
    
    static var device: String = {
        return UIDevice().type.rawValue
    }()
    
    static var sdkVersion: Int = {
        return 1
    }()
    
    static var system: String = {
        return UIDevice.current.systemVersion
    }()
    
    static var carrier: String = {
        
        let networkInfo = CTTelephonyNetworkInfo()
        if let carriers = networkInfo.serviceSubscriberCellularProviders
        {
            for (key, value) in carriers {
                if let carrier = value.carrierName {
                    return carrier
                }
            }
        }
        return "Unknown Carrier"
    }()
    
    static var bearer: String = {
       
        guard let token = APIToken.read()?.token else {
            return ""
        }
        return  "Bearer \(token)"
    }()
    
    // MARK: - Private Init
    private init(){}
    
    // MARK: - Private Static
    private static func getProperty(for key: String) -> String?
    {
        guard let plist = Bundle.main.infoDictionary else {
            fatalError("FATAL ERROR: Info.plist not found!")
        }

        guard let value: String = plist[key] as? String else {
            return nil
        }

        return value
    }
}


    
    
