//
//  ZipzClusters.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 30/07/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

class ZipzClusters
{
    private let router = Router<AppAPI>()
    
    func all(_ parameters: [String:Any],
             completion: @escaping (_ clusters: [Cluster]?, _ error: String?)->()) {
        
        router.request(.clusters(parameters: parameters)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection: \(error!)")
            }
            
            if let response = response as? HTTPURLResponse
            {
                let result = self.router.handleNetworkResponse(response)
                
                switch result
                {
                case .success:
                    
                    // Save the time of last "venue_clusters" request success
                    SavedDefaults.setLastCallTime(for: "venue_clusters")
                    
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
                        let clusters = apiResponse.response.clusters
                        clusters?.forEach({ cluster in
                            Cluster.save(cluster)
                        })
                        completion(clusters, nil)
                    }
                    catch let error as NSError {
                        
                        ZipzSDK.debugLog("🧨 Clusters decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
   func get(for parameters: [String:Any],
                completion: @escaping (_ cluster: Cluster?, _ error: String?)->()) {
        
        router.request(.clusterDetails(parameters: parameters)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection: \(error!)")
            }
            
            if let response = response as? HTTPURLResponse
            {
                let result = self.router.handleNetworkResponse(response)
                
                switch result
                {
                case .success:
                    
                    // Save the time of last "venue_cluster_details" request
                    SavedDefaults.setLastCallTime(for: "venue_cluster_details")
                    
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
                        let cluster = apiResponse.response.cluster
                        
                        completion(cluster, nil)
                    }
                    catch let error as NSError {
                        
                        ZipzSDK.debugLog("🧨 Cluster details decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}
