//
//  APIServices.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 24..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit

protocol APIService {
}

extension APIService {
    static func url(_ path: String) -> String {
        return "http://168.62.38.254:8888" + path
    }
}
