//
//  EnergyService.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 24..
//  Copyright © 2018년 박세은. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct EnergyService: APIService, RequestService{
    
    static let shareInstance = EnergyService()
    let URL = url("/energy")
    typealias NetworkData = EnergyData
    
    func getEnergyInfo(lat: Double, lon: Double, angle: Int,completion: @escaping (Energy) -> Void, error: @escaping (Int) -> Void) {
        let energyURL = URL + "/\(lat)/\(lon)/\(angle)"
        
        gettable(energyURL, body: nil, header: nil) { res in
            switch res {
            case .success(let EnergyData):
                let data = EnergyData.data
                completion(data)
            case .successWithNil(_):
                break
            case .error(let errCode):
                error(errCode)
            }
        }
    }
    
}
