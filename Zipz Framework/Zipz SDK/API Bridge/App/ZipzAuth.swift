//
//  ZipzAuth.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 25/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import AdSupport

class ZipzAuth: ZipzSDK
{
    private let router = Router<AuthAPI>()
    
    public func registerUser(with parameters: [String:Any], completion: @escaping (_ uuid: String?, _ error: String?)->())
    {
        var params = parameters
        params["app_id"] = APIManager.id
        params["app_secret"] = APIManager.secret
        
        router.request(.register(parameters: params)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection: \(error!)")
            }
            
            if let response = response as? HTTPURLResponse
            {
                let result = self.router.handleNetworkResponse(response)
                
                guard let responseData = data else {
                    completion(nil, NetworkResponse.noData.rawValue)
                    return
                }
                
                // Uncomment this to debug network response.
                NetworkLogger.debug(responseData)
                
                switch result
                {
                    case .success:
                        
                        do {
                            let decoder = JSONDecoder()
                            let apiResponse = try decoder.decode(APIResponse.self, from: responseData)
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            
                            guard let user = apiResponse.response.user else {
                                
                                completion(nil, nil)
                                return
                            }
                            
                            User.save(user)
                            completion(user.uuid, nil)
                          
                        }
                        catch let error as NSError {
                            
                            debugLog("🧨 Register decode ERROR: \(error.userInfo)")
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                }
            }
        }
    }
    
    public func initUser(with uuid: String, completion: @escaping (_ token: String?, _ error: String?)->())
    {
        let parameters: [String:Any] = ["uuid":uuid,
                                        "app_id":APIManager.id,
                                        "app_secret":APIManager.secret,
                                        "device":APIManager.device,
                                        "os" : "ios",
                                        "os_version":APIManager.system,
                                        "sdk_version":APIManager.sdkVersion,
                                        "carrier":APIManager.carrier]
        
        router.request(.login(parameters: parameters)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection: \(error!)")
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, "No or ivnalid response!")
                return
            }
            
            guard let responseData = data else {
                completion(nil, NetworkResponse.noData.rawValue)
                return
            }
            
            // Uncomment this to debug network response.
            NetworkLogger.debug(responseData)
            
            let result = self.router.handleNetworkResponse(response)
              
            switch result
            {
                case .success:
                
                    do {
                        let decoder = JSONDecoder()
                        let apiResponse = try decoder.decode(APIResponse.self, from: responseData)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        if let user = apiResponse.response.user {
                             User.save(user)
                        }
                        
                        if let ads = apiResponse.response.advertisingIDs {
                            
                            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                                let advertisingID = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        
                                if !ads.contains(advertisingID) {
                                    self.registerAdvertising(id: advertisingID) { _,_ in }
                                }
                            }
                        }
                        
                        guard let token = apiResponse.response.token else {
                            
                            completion(nil, "Invalid or missing auth token.")
                            return
                        }
                        
                        let apiToken = APIToken(token: token, showRegistration: false)
                        apiToken.save()
                       
                        completion(token, nil)
                      
                    }
                    catch let error as NSError {
                        
                        debugLog("🧨 INIT decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
            }
        }
    }
    
    public func registerAdvertising(id: String, completion: @escaping (_ success: Bool, _ error: String?)->())
    {
        router.request(.advertising(id: id)) { (data, response, error) in
            
            if error != nil {
                completion(false, "Please check your network connection: \(error!)")
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(false, "No or ivnalid response!")
                return
            }
            
            guard let responseData = data else {
                completion(false, NetworkResponse.noData.rawValue)
                return
            }
            
            // Uncomment this to debug network response.
            NetworkLogger.debug(responseData)
            let result = self.router.handleNetworkResponse(response)
            
            switch result
            {
                case .success:
                completion(true, nil)
                
                case .failure(let networkFailureError):
                completion(false, networkFailureError)
            }
        }
    }
}
