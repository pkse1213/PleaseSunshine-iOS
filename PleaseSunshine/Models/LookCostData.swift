//
//  CostData.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 24..
//  Copyright © 2018년 박세은. All rights reserved.
//

import Foundation

struct LookCostData: Codable {
    let message: String
    let data: [LookCost]
}

struct LookCost: Codable {
    let watt, savedMoney, installCostAvg: Int
    let bePoint: Double
}
