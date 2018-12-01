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
    let data: DataClass
}

struct DataClass: Codable {
    let nox, sox, udst: Nox
    let busansox: Int
}

struct Nox: Codable {
    let sun: Int
    let kospo, thermalPower: Double
    
    enum CodingKeys: String, CodingKey {
        case sun, kospo
        case thermalPower = "thermal_power"
    }
}
