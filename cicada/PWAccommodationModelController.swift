//
//  PWAccommodationModelController.swift
//  cicada
//
//  Created by Ping on 22/11/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//
//
// The page data model for the Accommodation Request Publish pages

import UIKit

class PWAccommodationModelController: NSObject, UIPageViewControllerDataSource  {
    
    var pages: [UIViewController?] = [UIViewController?](count: 3, repeatedValue: nil)
    var pageNames: [String] = ["destinationPageVC", "accommodationPageVC", "confirmationPageVC"]

    override init() {
        super.init()
    }
    
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> UIViewController? {
        // Return the data view controller for the given index.
        if (index < 0 || index > 2) {
            return nil
        }
        
        var vc: UIViewController? = pages[index]
        if (vc == nil) {
            // Create a new view controller and pass suitable data.
            // Question: Taking speed and memory into consideration, should we cache the newly created view controller or not???
            let vcName = pageNames[index]
            vc = storyboard.instantiateViewControllerWithIdentifier(vcName) as UIViewController

            pages[index] = vc
        }

        return vc
    }
    
    func indexOfViewController(viewController: UIViewController) -> Int {
        // Return the index of the given data view controller.
        for index in 0...(pages.count-1) {
            if pages[index] == viewController {
                return index
            }
        }
        
        return NSNotFound
        
//        find method cannot compare nil
//        if let index = find(pages, viewController) {
//            return index
//        } else {
//            return NSNotFound
//        }
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as UIViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as UIViewController)
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == self.pages.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
}
