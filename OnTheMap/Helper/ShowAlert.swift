//
//  ShowAlert.swift
//  OnTheMap
//
//  Created by Faisal Babkoor on 11/14/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit
struct ShowAlert {
    static func showAlert(title: String, message: String, vc: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}
