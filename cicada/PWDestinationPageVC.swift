//
//  PWDestinationPageVC.swift
//  cicada
//
//  Created by Ping on 4/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit

class PWDestinationPageVC: UIViewController {

    @IBOutlet var destinationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        destinationTextView.sizeToFit()

        registerAction(destinationTextView, action:"showDestinationTableVC")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func registerAction(view: UIView, action: String) {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(action))
        view.userInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
        
        println("registering action for view \(view). action=\(action)")
        
    }

    func showDestinationTableVC() {
        println("************ Destination text view clicked")
        //self.performSegueWithIdentifier("segueShowMap", sender: nil)
        
        
        let destinationTableVC = self.storyboard!.instantiateViewControllerWithIdentifier("destionationTableVC") as UIViewController

        // hook data
        // mapVC.businessEntity = selectedBusinessEntity
        
        // iOS7 comptible
        // self.navigationController?.pushViewController(destinationTableVC, animated: true)
        
        // iOS8 comptible
        self.showViewController(destinationTableVC as UIViewController, sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
