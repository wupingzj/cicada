//
//  PWViewControllerUtils.swift
//  cicada
//
//  Created by Ping on 5/01/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation
import UIKit

class PWViewControllerUtils {
    class func showAlertMsg(viewVC: UIViewController, title: String, message: String) {
        // TODO: UIAlertController requires iOS8
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,
            handler: { action in
        })
        alertController.addAction(okAction)
        viewVC.presentViewController(alertController, animated: true, completion: nil)
    }
}