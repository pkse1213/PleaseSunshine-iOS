
//
//  CostService.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 24..
//  Copyright © 2018년 박세은. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct CostService: APIService, RequestService{
    
    static let shareInstance = CostService()
    let URL = url("/cost")
    typealias NetworkData = CostData
    
    func getCostInfo(watt: Int, completion: @escaping (Cost) -> Void, error: @escaping (Int) -> Void) {
        let costURL = URL + "/\(watt)"
        
        gettable(costURL, body: nil, header: nil) { res in
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
