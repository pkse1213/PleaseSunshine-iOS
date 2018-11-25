//
//  LookCostService.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 25..
//  Copyright © 2018년 박세은. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct LookCostService: APIService, RequestService{
    
    static let shareInstance = LookCostService()
    let URL = url("/cost")
    typealias NetworkData = LookCostData
    
    
    func getCostLookInfo(completion: @escaping ([LookCost]) -> Void, error: @escaping (Int) -> Void) {
        gettable(URL, body: nil, header: nil) { res in
            switch res {
            case .success(let CostData):
                let data = CostData.data
                completion(data)
            case .successWithNil(_):
                break
            case .error(let errCode):
                error(errCode)
            }
        }
    }
    
}
