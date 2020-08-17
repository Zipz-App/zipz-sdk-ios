//
//  ZipzOffers.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 30/07/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

class ZipzOffers
{
    private let router = Router<AppAPI>()
    
    func get(uuid: String, completion: @escaping (_ offer: Offer?, _ error: String?)->())
    {
        router.request(.offerDetails(uuid: uuid)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection: \(error!)")
            }
            
            if let response = response as? HTTPURLResponse
            {
                let result = self.router.handleNetworkResponse(response)
                
                switch result
                {
                case .success:
                    
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    // Uncomment this to debug network response.
                    // NetworkLogger.debug(responseData)
                    
                    do {
                        let decoder = JSONDecoder()
                        let apiResponse = try decoder.decode(APIResponse.self, from: responseData)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let offer = apiResponse.response.offer
   
                        if let offer = offer {
                            Offer.save(offer)
                        }
                
                        completion(offer, nil)
                    }
                    catch let error as NSError {
                        
                        ZipzSDK.debugLog("🧨 OFFER decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func reserve(uuid: String, completion: @escaping (_ offer: Offer?, _ error: String?)->())
    {
        router.request(.reserveOffer(uuid: uuid)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection: \(error!)")
            }
            
            if let response = response as? HTTPURLResponse
            {
                let result = self.router.handleNetworkResponse(response)
                
                switch result
                {
                case .success:
                    
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    // Uncomment this to debug network response.
                    // NetworkLogger.debug(responseData)
                    
                    do {
                        let decoder = JSONDecoder()
                        let apiResponse = try decoder.decode(APIResponse.self, from: responseData)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let offer = apiResponse.response.reserveOffer
                        
                        if let offer = offer {
                            Offer.save(offer)
                        }
                        
                        completion(offer, nil)
                    }
                    catch let error as NSError {
                        
                        ZipzSDK.debugLog("🧨 RESERVE OFFER decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}
