
//
//  EnvironmentService.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 24..
//  Copyright © 2018년 박세은. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct EnvironmentService: APIService, RequestService{
    
    static let shareInstance = EnvironmentService()
    let URL = url("/environment")
    typealias NetworkData = EnvironmentData
    
    func getEnvironmentInfo(completion: @escaping (Int) -> Void, error: @escaping (Int) -> Void) {
        gettable(URL, body: nil, header: nil) { res in
            switch res {
            case .success(let CostData):
                let data = CostData.data.busansox
                completion(data)
            case .successWithNil(_):
                break
            case .error(let errCode):
                error(errCode)
            }
        }
    }
    
}
