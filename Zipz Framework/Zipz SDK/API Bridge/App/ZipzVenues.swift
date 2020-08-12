//
//  ZipzVenues.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 30/07/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

class ZipzVenues: ZipzSDK
{
    private let router = Router<AppAPI>()
    
    public func all(completion: @escaping (_ venues: [Venue]?, _ error: String?)->())
    {
        var parameters: [String:Any] = [:]
        
        if let savedDate = SavedDefaults.getLastCallTime(for: "venues") {
            parameters["datetime"] = savedDate
        }
        
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
                    NetworkLogger.debug(responseData)
                    
                    do {
                        let decoder = JSONDecoder()
                        let apiResponse = try decoder.decode(APIResponse.self, from: responseData)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let venues = apiResponse.response.venues
                        venues?.forEach({ venue in
                            Venue.save(venue)
                        })
                        
                        completion(venues, nil)
                    }
                    catch let error as NSError {
                        
                        debugLog("🧨 Venues decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    public func get(uuid: String, completion: @escaping (_ venue: Venue?, _ error: String?)->())
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
                    NetworkLogger.debug(responseData)
                    
                    do {
                        let decoder = JSONDecoder()
                        let apiResponse = try decoder.decode(APIResponse.self, from: responseData)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let venue = apiResponse.response.venue
                        
                        if let venue = venue {
                            Venue.save(venue)
                        }
                
                        completion(venue, nil)
                    }
                    catch let error as NSError {
                        
                        debugLog("🧨 Venue decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}
