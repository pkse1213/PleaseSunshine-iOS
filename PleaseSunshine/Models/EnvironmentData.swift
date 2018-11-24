//
//  File.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 24..
//  Copyright © 2018년 박세은. All rights reserved.
//

import Foundation

struct EnvironmentData: Codable {
    let message: String
    let data: OutputClass
}

struct OutputClass: Codable {
    let cado, nox, udst: OutputAmount
}

struct OutputAmount: Codable {
    let sun, kospo, thermalPower: Int
    
    enum CodingKeys: String, CodingKey {
        case sun, kospo
        case thermalPower = "thermal_power"
    }
}
