//
//  PWAccommodationRequestVC.swift
//  cicada
//
//  Created by Ping on 22/11/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//
// Accommodation Requet Publish view controller.

import UIKit

class PWAccommodationRequestVC: UIViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.delegate = self
        
        
        /////////////////
        let destinationPage: UIViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
        let viewControllers: NSArray = [destinationPage]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
        
        self.pageViewController!.dataSource = self.modelController
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
//        var pageViewRect = self.view.bounds
        let size = self.view.bounds.size
        var pageViewRect = CGRectMake(0, 0, size.width, size.height - 58.0)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
        }
        self.pageViewController!.view.frame = pageViewRect
        
        self.pageViewController!.didMoveToParentViewController(self)
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
        
        /////////////////
        
        setupPageControl()
    }
    
    func setupPageControl() {
        let pageControl:UIPageControl = UIPageControl.appearance();
        pageControl.pageIndicatorTintColor = UIColor.blueColor()
        pageControl.currentPageIndicatorTintColor = UIColor.greenColor()
        pageControl.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var modelController: PWAccommodationModelController {
        if _modelController == nil {
            _modelController = PWAccommodationModelController()
            }
            return _modelController!
    }
    var _modelController: PWAccommodationModelController? = nil


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
