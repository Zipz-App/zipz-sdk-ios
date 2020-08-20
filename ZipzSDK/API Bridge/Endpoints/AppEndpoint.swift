//
//  AppEndpoint.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 16/05/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

public enum AppAPI
{
    case venues(parameters: Parameters)
    case venueDetails(uuid: String)
    case clusters(parameters: Parameters)
    case clusterDetails(parameters: Parameters)
    case offerDetails(uuid: String)
    case reserveOffer(uuid: String)
    case transactions
    case redeemTransaction(parameters: Parameters)
}

extension AppAPI: EndpointProtocol
{
    var method: HTTPMethod { return .post }
    var headers: HTTPHeaders? { return ["Authorization":APIManager.bearer] }
    
    var environmentBaseURL : String
    {
        switch APIManager.environment {
            
        case .production: return "\(APIManager.productionBase)\(APIManager.verison)"
        case .staging: return ""
        case .development: return "\(APIManager.developmentBase)\(APIManager.verison)"
        }
    }
    
    var baseURL: URL
    {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("Base URL could not be configured.")
        }
        return url
    }
     
    var path: String
    {
        switch self {
            
        case .venues:
            return "venues"
        case .venueDetails:
            return "venue_details"
        case .clusters:
            return "/venue_clusters"
        case .clusterDetails:
            return "/venue_cluster_details"
        case .offerDetails:
            return "/offer_details"
        case .reserveOffer:
            return "/reserve_offer"
        case .transactions:
            return "/transactions"
        case .redeemTransaction:
            return "/redeem_transaction"
        }
    }
    
    var task: HTTPTask
    {
        switch self {
        
        case .venues(let parameters):
            return .requestParametersAndHeaders(bodyParameters: parameters, additionHeaders: headers)
        case .venueDetails(let uuid):
            let parameters = ["uuid" : uuid]
            return .requestParametersAndHeaders(bodyParameters: parameters, additionHeaders: headers)
        case .clusters(let parameters):
            return .requestParametersAndHeaders(bodyParameters: parameters, additionHeaders: headers)
        case .clusterDetails(let parameters):
            return .requestParametersAndHeaders(bodyParameters: parameters, additionHeaders: headers)
        case .offerDetails(let uuid):
            let parameters = ["uuid" : uuid]
            return .requestParametersAndHeaders(bodyParameters: parameters, additionHeaders: headers)
        case .reserveOffer(let uuid):
            let parameters = ["uuid" : uuid]
            return .requestParametersAndHeaders(bodyParameters: parameters, additionHeaders: headers)
        case .transactions:
            return .requestParametersAndHeaders(additionHeaders: headers)
        case .redeemTransaction(let parameters):
            return .requestParametersAndHeaders(bodyParameters: parameters, additionHeaders: headers)
        }
    }
}
