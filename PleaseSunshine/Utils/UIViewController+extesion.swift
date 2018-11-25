//
//  UIViewController+Extesion.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 24..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func simpleAlertWithCompletion(title: String, message: String, okCompletion: ((UIAlertAction) -> Void)?, cancelCompletion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okCompletion)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelCompletion)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func simpleAlertWithCompletionOnlyOk(title: String, message: String, okCompletion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okCompletion)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func gsno(_ value:String?)-> String{
        guard let value_ = value else {
            return ""
        }
        return value_
    }//func gsno
    
    func gino(_ value:Int?) -> Int{
        guard let value_ = value else {
            return 0
        }
        return value_
    }//func gino
    
    func gbno(_ value:Bool?)->Bool{
        guard let value_ = value else {
            return false
        }
        return value_
    }//func gbno
    
    func gfno(_ value:Float?)->Float{
        guard let value_ = value else{
            return 0
        }
        return value_
    }//func gfno
}
