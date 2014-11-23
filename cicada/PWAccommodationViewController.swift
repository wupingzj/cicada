//
//  PWAccommodationViewController.swift
//  cicada
//
//  Created by Ping on 23/11/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit

class PWAccommodationViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let colors: [UIColor] = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor()]
        let width: CGFloat = self.scrollView.frame.size.width
        let height: CGFloat = self.scrollView.frame.size.height
        
        for index in 0..<colors.count { // half-closed range operator
            
            var x:CGFloat = width * CGFloat(index)
            
            let subView: UIView = UIView(frame: CGRectMake(x, 0, width, height))
            subView.backgroundColor = colors[index]
            self.scrollView.addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSizeMake(width * CGFloat(colors.count), height);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
