//
//  Config.swift
//  PhotoEditing
//
//  Created by Mahesh Sapkota, Sarad Poudel and Kritartha Kafle on 04/25/21.

import Foundation
import UIKit

struct Config {
    
    static var STORAGE_ROOF_REF = "gs://carservice-e5ea6.appspot.com"
    
}


func showAlertViewWithTitle(_ title:String?, message:String, buttonTitles:[String], viewController:UIViewController, completion: ((_ index: Int) -> Void)?) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for buttonTitle in buttonTitles {
        let alertAction = UIAlertAction(title: buttonTitle, style: .default, handler: { (action:UIAlertAction) in
            completion?(buttonTitles.firstIndex(of: buttonTitle)!)
        })
        alertController .addAction(alertAction)
    }
    viewController .present(alertController, animated: true, completion: nil)
}


var lat = 0.0
var lon = 0.0
