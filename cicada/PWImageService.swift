//
//  PWImageService.swift
//  cicada
//
//  Created by Ping on 26/04/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PWImageService {
    class func loadDestinationImage2(imageUrl: String, completionHandler:(ok: Bool) -> Void) {
    }
    
    class func getQuoteImagePlaceHolderFileName() -> String {
        // returns the file name of the quote image place holder.
        // This is to be displayed when network is not available and cannot get quote hotel image(s)
        
        // TODO
        return "QuoteImagePlaceHolderFile"
    }
    
    class func loadDestinationImage(imageView: UIImageView, imageUrl: String, completionHandler:(ok: Bool) -> Void) {
        // TODO
        // if wi-fi, load multiple images
        // if mobile-data, load only two images
        
        // ref: http://stackoverflow.com/questions/24231680/swift-loading-image-from-url
        //      http://www.raywenderlich.com/85080/beginning-alamofire-tutorial
        //      http://www.raywenderlich.com/87595/intermediate-alamofire-tutorial
        //      for synchronous and asynchronous image loading
        let fullImageUrl: String = PWNetworkService.sharedInstance.getURLBase() + imageUrl
        
        // approach 1: synchrnously fetch image
        /* 
        if let url = NSURL(string: fullImageUrl) {
            if let imageData = NSData(contentsOfURL: url) {
                self.destinationImageView.image = UIImage(data: imageData)
            } else {
                println("Failed to load data with URL \(url)")
            }
        } else {
            println("Invalid urlStr: \(fullImageUrl)")
        }
        */
        
        // approach 2: asynchronously fetch image
        Alamofire.request(.GET, fullImageUrl)
            .validate()
            .response() { (request, response, data, error) in
                var ok = false
                
                if error == nil && data != nil {
                    if let image = UIImage(data: data! as NSData) {
                        // self.destinationImageView.image = image
                        
                        // TODO - animate multiple images
                        var images: [UIImage] = []
                        images.append(image)
//                        images.append(image)
//                        images.append(image)
                        
                        imageView.animationImages = images
                        imageView.animationDuration = 5
                        imageView.startAnimating()
                        
                        // self.imageView.frame = self.centerFrameFromImage(image)
                        // self.spinner.stopAnimating()
                        // self.centerScrollViewContents()
                        
                        ok = true
                    }
                } else {
                    println("Failed to retrieve image at URL: \(fullImageUrl)")
                }
                
                if !ok {
                    println("Download destination image failed. Use default image instead.")
                    // TODO - load default local country image
                    completionHandler(ok: false)
                }
        }
    }
    
    // Load image from local file named by imageFileName
    class func loadDestinationImageFromLocalFile(imageView: UIImageView, imageFileName: String) {
//        //TODO
//        let imageFileName = "NewZealand.3.jpg"
        if let image = UIImage(named: imageFileName) {
            imageView.image = image
        } else {
            // could not load the image
            println("Failed to load image from file \(imageFileName)")
        }
    }
}