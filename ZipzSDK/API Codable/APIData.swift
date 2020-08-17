//
//  APIData.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 09/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

struct APIData: Codable
{
    let user: User?
    let token: String?
    let showRegistration: Bool?
    let advertisingIDs: [String]?
    let missingFields: [String]?
    let sessionID: Int?
    let notificationToken: String?
    let update: APIUpdate?
    let clusters: [Cluster]?
    let cluster: Cluster?
    let venues: [Venue]?
    let venue: Venue?
    let offer: Offer?
    let reserveOffer: Offer?
    let transactions: [Transaction]?
    let transaction: Transaction?
    
    private enum CodingKeys: String, CodingKey
    {
        case user = "app_user"
        case showRegistration = "show_registration_profile"
        case advertisingIDs = "advertising_id"
        case sessionID = "session_id"
        case clusters = "venue_clusters"
        case cluster = "venue_cluster"
        case transaction = "redeem_transaction"
        case token, missingFields, notificationToken, update
        case venues, venue, offer, transactions
        case reserveOffer = "reserve_offer"
    }
}
