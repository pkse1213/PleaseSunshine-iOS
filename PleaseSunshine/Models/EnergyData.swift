
//
//  EnergyData.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 24..
//  Copyright © 2018년 박세은. All rights reserved.
//

import Foundation

struct EnergyData: Codable {
    let message: String
    let data: Energy
}

struct Energy: Codable {
    let sunshine: Double
    let persent: Double
}
