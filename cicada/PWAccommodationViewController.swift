//
//  PWAccommodationViewController.swift
//  cicada
//
//  Created by Ping on 23/11/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

// Ref: http://www.iosdevnotes.com/2011/03/uiscrollview-paging/

import UIKit

class PWAccommodationViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var pageControl: UIPageControl!
    
    var pageControlBeingUsed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.pageControlBeingUsed = false
        
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
        //self.view.backgroundColor = UIColor.blackColor()
        
        self.scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !pageControlBeingUsed {
            // Update the page when more than 50% of the previous/next page is visible
            let pageWidth = scrollView.frame.size.width;
            let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            self.pageControl.currentPage = Int(page);
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.pageControlBeingUsed = false
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.pageControlBeingUsed = false
    }
    
    @IBAction func changePage(sender: UIPageControl) {
        let pageWidth = scrollView.frame.size.width;
        let pageHeight = scrollView.frame.size.height
        let x: CGFloat = pageWidth * CGFloat(self.pageControl.currentPage)
        let frame: CGRect = CGRectMake(x, 0, pageWidth, pageHeight)
        
        self.scrollView.scrollRectToVisible(frame, animated: true)
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
