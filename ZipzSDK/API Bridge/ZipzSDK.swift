//
//  ZipzSDK.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 16/05/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

public class ZipzSDK: NSObject {
    
    // MARK: - Authorization
    public class func registerUser(with parameters: [String:Any], completion: @escaping (_ uuid: String?, _ error: String?)->()) {
        
        ZipzAuth().registerUser(with: parameters) { uuid, error in
                completion(uuid, error)
        }
    }
    
    public class func initUser(with uuid: String, completion: @escaping (_ token: String?, _ error: String?)->()) {
        
        ZipzAuth().initUser(with: uuid) { token, error in
                completion(token, error)
        }
    }
    
    
    // MARK: - VENUE CLUSTERS
    public class func allClusters(fetch: FetchType = .update,
                                   type: ClusterType? = nil,
                                   state: String? = nil,
                                   city: String? = nil,
                                   completion: @escaping (_ clusters: [Cluster]?, _ error: String?)->()) {
        
        var parameters: [String:Any] = [:]
        
        if let savedDate = SavedDefaults.getLastCallTime(for: "venue_clusters"), fetch == .update {
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
        
        ZipzClusters().all(parameters) { clusters, error in
            completion(clusters, error)
        }
    }
    
    public class func cluster(with uuid: String,
                              fetch: FetchType = .update,
                              completion: @escaping (_ cluster: Cluster?, _ error: String?)->()) {
        
        var parameters: [String:Any] = ["uuid":uuid]
        
        if let savedDate = SavedDefaults.getLastCallTime(for: "venue_cluster_details"), fetch == .update {
            parameters["datetime"] = savedDate
        }
        
        ZipzClusters().get(for: parameters) { cluster, error in
            completion(cluster, error)
        }
    }
    
    // MARK: - VENUES
    public static func allVenues(fetch: FetchType = .update,
    completion: @escaping (_ venues: [Venue]?, _ error: String?)->()) {
        
        var parameters: [String:Any] = [:]
        
        if let savedDate = SavedDefaults.getLastCallTime(for: "venues"), fetch == .update {
            parameters["datetime"] = savedDate
        }
        
        ZipzVenues().all(parameters: parameters) { venues, error in
            completion(venues, error)
        }
    }
    
    public static func venue(with uuid: String, completion: @escaping (_ venue: Venue?, _ error: String?)->()) {
        
        ZipzVenues().get(uuid: uuid) { venue, error in
            completion(venue, error)
        }
    }
    
    // MARK: - TRANSACTIONS
    public static func allTransactions(completion: @escaping (_ transactions: [Transaction]?, _ error: String?)->()) {
        
        ZipzTransactions().all() { transactions, error in
            completion(transactions, error)
        }
    }
    
    // MARK: - OFFERS
    public static func getOffer(with uuid: String, completion: @escaping (_ offer: Offer?, _ error: String?)->()) {
        
        ZipzOffers().get(uuid: uuid) { offer, error in
            completion(offer, error)
        }
    }
    
    public static func reserveOffer(with uuid: String, completion: @escaping (_ offer: Offer?, _ error: String?)->()) {
        
        ZipzOffers().reserve(uuid: uuid) { offer, error in
            completion(offer, error)
        }
    }
    
    public static func reedemOffer(with qrCode: String, uuid: String, completion: @escaping (_ transaction: Transaction?, _ error: String?)->()) {
           
        ZipzTransactions().redeem(with: qrCode, uuid: uuid) { transaction, error in
            completion(transaction, error)
        }
    }
    
    // MARK: - DEBUG CONSOLE LOG
    public static func debugLog(_ item: Any, logType: LogType = .log, file: NSString = #file, line: Int = #line, function: String = #function)
    {
        #if DEBUG
        switch logType {
        case .log:
            print("Zipz -- \(item)")
        case .error:
            print("Zipz Error -- \(item) in \(file.lastPathComponent)(\(line)) -> \(function)")
        case .detail:
            print("Zipz -- \(file.lastPathComponent)(\(line)):\(function): \(item)")
        }
        #endif
    }
}
