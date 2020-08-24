//
//  ZipzVenues.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 30/07/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

class ZipzVenues
{
    private let router = Router<AppAPI>()
    
    func all(parameters: [String:Any],
    completion: @escaping (_ venues: [Venue]?, _ error: String?)->()) {
        
        router.request(.venues(parameters: parameters)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection: \(error!)")
            }
            
            if let response = response as? HTTPURLResponse
            {
                let result = self.router.handleNetworkResponse(response)
                
                switch result
                {
                case .success:
                    
                    // Save the time of last "venues" request success
                    SavedDefaults.setLastCallTime(for: "venues")
                    
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
                        
                        guard let venues = apiResponse.response.venues else {
                            if let statusResponse = try? decoder.decode(APIStatus.self, from: responseData) {
                                let error = statusResponse.error?.message
                                completion(nil, error)
                            }
                            return
                        }
                        
                        venues.forEach({ venue in
                            Venue.save(venue)
                        })
                        
                        completion(venues, nil)
                    }
                    catch let error as NSError {
                        
                        ZipzSDK.debugLog("🧨 Venues decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func get(uuid: String, completion: @escaping (_ venue: Venue?, _ error: String?)->())
    {
        router.request(.venueDetails(uuid: uuid)) { (data, response, error) in
            
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
                        
                        guard let venue = apiResponse.response.venue else {
                            if let statusResponse = try? decoder.decode(APIStatus.self, from: responseData) {
                                let error = statusResponse.error?.message
                                completion(nil, error)
                            }
                            return
                        }
                        
                        Venue.save(venue)
                        completion(venue, nil)
                    }
                    catch let error as NSError {
                        
                       ZipzSDK.debugLog("🧨 Venue decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}
