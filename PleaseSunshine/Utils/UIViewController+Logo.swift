
//
//  UIViewController+Logo.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 23..
//  Copyright © 2018년 박세은. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setLogoInNaviBar() {
        let imgv = UIImageView(image: #imageLiteral(resourceName: "logo"))
        self.navigationItem.titleView = imgv
    }
}
