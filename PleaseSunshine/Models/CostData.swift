//
//  CostData.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 25..
//  Copyright © 2018년 박세은. All rights reserved.
//

import Foundation

struct CostData: Codable {
    let message: String
    let data: [Cost]
}

struct Cost: Codable {
    let watt, savedMoney, installCostAvg: Int
    let bePoint: Double
    let volunteer, coffee: Int
}
