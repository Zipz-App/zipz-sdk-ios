//
//  ZipzClusters.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 30/07/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

class ZipzClusters: ZipzSDK
{
    private let router = Router<AppAPI>()
    
    public func all(type: ClusterType? = nil, state: String? = nil, city: String? = nil, completion: @escaping (_ clusters: [Cluster]?, _ error: String?)->())
    {
        var parameters: [String:Any] = [:]
        
        
        
        if let savedDate = SavedDefaults.getLastCallTime(for: "venue_clusters"), let _ = Cluster.all() {
            parameters["datetime"] = savedDate
        }
        
        if let type = type {
            parameters["type"] = type.rawValue
        }
        
        if let state = state {
            parameters["state"] = state
        }
        
        if let city = city {
            parameters["city"] = city
        }
        
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
                    NetworkLogger.debug(responseData)
                    
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
                        
                        debugLog("🧨 Clusters decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    public func get(for uuid: String, completion: @escaping (_ clusters: Cluster?, _ error: String?)->())
    {
        var parameters: [String:Any] = ["uuid":uuid]
        
        if let savedDate = SavedDefaults.getLastCallTime(for: "venue_cluster_details") {
            parameters["datetime"] = savedDate
        }
        
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
                    NetworkLogger.debug(responseData)
                    
                    do {
                        let decoder = JSONDecoder()
                        let apiResponse = try decoder.decode(APIResponse.self, from: responseData)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let cluster = apiResponse.response.cluster
                        
                        completion(cluster, nil)
                    }
                    catch let error as NSError {
                        
                        debugLog("🧨 Cluster details decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}
