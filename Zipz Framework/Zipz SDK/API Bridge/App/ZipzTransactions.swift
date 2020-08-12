//
//  ZipzTransactions.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 30/07/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation

class ZipzTransactions: ZipzSDK
{
    private let router = Router<AppAPI>()
    
    public func all(completion: @escaping (_ transactions: [Transaction]?, _ error: String?)->())
    {
        router.request(.transactions) { (data, response, error) in
            
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
                        
                        guard let transactions = apiResponse.response.transactions else {
                            completion(nil, nil)
                            return
                        }
                        
                        transactions.forEach { transaction in
                            Transaction.save(transaction)
                        }
                        
                        completion(transactions, nil)
                    }
                    catch let error as NSError {
                        
                        debugLog("🧨 ALL TRANSACTIONS decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    public func redeem(with qrCode: String, uuid: String, completion: @escaping (_ transaction: Transaction?, _ error: String?)->())
    {
        let parameters = ["uuid":uuid, "qr_code":qrCode]
        
        router.request(.redeemTransaction(parameters: parameters)) { (data, response, error) in
            
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
                        
                        guard let transaction = apiResponse.response.transaction else {
                            completion(nil, nil)
                            return
                        }
                        
                        Transaction.save(transaction)
                        completion(transaction, nil)
                    }
                    catch let error as NSError {
                        
                        debugLog("🧨 REDEEM TRANSACTION decode ERROR: \(error.userInfo)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}
