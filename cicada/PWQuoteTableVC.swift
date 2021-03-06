//
//  PWQuoteTableVC.swift
//  cicada
//
//  Created by Ping on 13/03/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class PWQuoteTableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    var request: PWRequest!
    
    var lastSelectedCell: UITableViewCell? = nil
    var ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fine-tune the table view
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.showsVerticalScrollIndicator = false
        // self.tableView.indicatorStyle =  UIScrollViewIndicatorStyle.White

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        if request == nil {
            // TODO - low priority: show alert that request has not been selected yet
        }
        
        // setup refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Refresh table
    func reloadTableView() {
        // reset fetchResultController to reflect the data change
        _fetchedResultsController = nil
        self.tableView.reloadData()
    }
    
    func refresh() {
        // TODO - review this method
        if let refreshControl = self.refreshControl {
            refreshControl.attributedTitle = NSAttributedString(string: "Refreshing data...")
            
            PWCountryService.sharedInstance.downloadAllCountries({data, error, redirectToLogon in
                println("**** doing callback with data=\(data), error=\(error)")
                
                // Note: the network call is asynchronized.
                refreshControl.endRefreshing()
                
                if redirectToLogon {
                    PWViewControllerUtils.showAlertMsg(self, title: "Sorry", message: "Please logon first and then try again")
                    
                    // TODO - switch GUI to login screen
                } else {
                    var ok = false
                    if let err = error {
                        println("Failed to download country list.")
                    } else {
                        if let dataUnwrapped: AnyObject = data  {
                            // data returned, parse and persist data
                            let json = JSON(dataUnwrapped)
                            ok = PWCountryService.sharedInstance.parseAndPersistCountries(json)
                        } else {
                            println("Connected to server but no data returned from cicada server.")
                        }
                    }
                    
                    if ok {
                        self.reloadTableView()
                    } else {
                        PWViewControllerUtils.showAlertMsg(self, title: "Sorry", message: "Failed to refresh quote list. Please try again later")
                    }
                }
            })
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        } else {
            println("ERROR@PWQuoteTableVC: No sections found!")
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            let sectionInfo = sections[section] as NSFetchedResultsSectionInfo
            return sectionInfo.numberOfObjects
        } else {
            println("ERROR@PWQuoteTableVC: No sections found!")
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // This is the sum of the heights of imageView, briefLabel, descLabel
        return 190
    }
    
    // MARK: - Table view layout
    let QUOTE_PHOTO_TAG = 1000
    let QUOTE_PRICE_TAG = 1001
    let QUOTE_BRIEF_TAG = 1002
    let QUOTE_DESCRIPTION_TAG = 1003
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get data
        let quote:PWQuote = self.fetchedResultsController.objectAtIndexPath(indexPath) as PWQuote
        
        let cellID = "quoteCellProgramatically"
//        let cellID = "quoteCell"
        var cell: UITableViewCell!
        if let tryCell = tableView.dequeueReusableCellWithIdentifier(cellID) as UITableViewCell? {
            cell = tryCell
        } else {
            cell = createCell(cellID)
        }
        
        let imageView = cell.contentView.viewWithTag(QUOTE_PHOTO_TAG) as UIImageView
        let priceLabel = cell.contentView.viewWithTag(QUOTE_PRICE_TAG) as UILabel
        let briefLabel = cell.contentView.viewWithTag(QUOTE_BRIEF_TAG) as UILabel
        let descLabel = cell.contentView.viewWithTag(QUOTE_DESCRIPTION_TAG) as UILabel
        
        priceLabel.text = "$350"
        briefLabel.text = "Bondi Beach Hotel - Magnificant sea view"
//        briefLabel.text = "This is the brief \ndescription of the quote. abcdefghijklmnopqrstuvwxyz This is another bit of description"
        descLabel.text = "details - details - details"
        
        return cell
    }
    
    private func createCell(cellID: String) -> UITableViewCell {
        // Keep in mind: when the elements of cell is added/removed or their heights are adjusted, 
        // change heightForRowAtIndexPath value accordingly
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID)
        
        // create image
        let imageView: UIImageView = UIImageView()
        cell.contentView.addSubview(imageView)
        imageView.tag = QUOTE_PHOTO_TAG
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleHeight
        imageView.backgroundColor = UIColor.greenColor()
        let imageUrl = "TODO_ImageUrlOfTheQuote"
        displayDestinationImage(imageView, imageUrl: imageUrl)

        
        // create price label
        let priceLabel = UILabel()
        cell.contentView.addSubview(priceLabel)
        priceLabel.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleHeight
        priceLabel.tag = QUOTE_PRICE_TAG
        priceLabel.font = UIFont.boldSystemFontOfSize(20.0)
        priceLabel.textAlignment = NSTextAlignment.Left
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.backgroundColor = UIColor.darkGrayColor()


        // create brief label
        let briefLabel = UILabel()
        cell.contentView.addSubview(briefLabel)
        briefLabel.tag = QUOTE_BRIEF_TAG
        briefLabel.font = UIFont.boldSystemFontOfSize(14.0)
        briefLabel.textAlignment = NSTextAlignment.Left
        briefLabel.textColor = UIColor.darkGrayColor()
        briefLabel.numberOfLines = 0
        briefLabel.adjustsFontSizeToFitWidth = true
        // briefLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        // briefLabel.backgroundColor = UIColor.redColor()
        
        // create brief label
        let descLabel = UILabel()
        cell.contentView.addSubview(descLabel)
        descLabel.tag = QUOTE_DESCRIPTION_TAG
        descLabel.font = UIFont.systemFontOfSize(12.0)
        descLabel.textAlignment = NSTextAlignment.Left
        descLabel.textColor = UIColor.darkGrayColor()
        descLabel.numberOfLines = 0
        descLabel.adjustsFontSizeToFitWidth = true
        // descLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        // descLabel.backgroundColor = UIColor.blueColor()

        var contentViewsDictionary: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        contentViewsDictionary["imageView"] = imageView
        contentViewsDictionary["priceLabel"] = priceLabel
        contentViewsDictionary["briefLabel"] = briefLabel
        contentViewsDictionary["descLabel"] = descLabel
        
        var formatH1 = "H:|[imageView(>=50)]|"
        var formatH2 = "H:|-[priceLabel]"
        var formatH3 = "H:|-[briefLabel(>=50)]-|"
        var formatH4 = "H:|-[descLabel(>=50)]-|"
        var constraintsH1 = NSLayoutConstraint.constraintsWithVisualFormat(formatH1, options: NSLayoutFormatOptions(0), metrics: nil, views: contentViewsDictionary)
        var constraintsH2 = NSLayoutConstraint.constraintsWithVisualFormat(formatH2, options: NSLayoutFormatOptions(0), metrics: nil, views: contentViewsDictionary)
        var constraintsH3 = NSLayoutConstraint.constraintsWithVisualFormat(formatH3, options: NSLayoutFormatOptions(0), metrics: nil, views: contentViewsDictionary)
        var constraintsH4 = NSLayoutConstraint.constraintsWithVisualFormat(formatH4, options: NSLayoutFormatOptions(0), metrics: nil, views: contentViewsDictionary)
        
        
        var formatV1: String = "V:|[imageView(>=150)]-(-30)-[priceLabel(20)]"
        var formatV2: String = "V:|[imageView(>=150)][briefLabel(20)][descLabel(20)]"
        var constraintsV1 = NSLayoutConstraint.constraintsWithVisualFormat(formatV1, options: NSLayoutFormatOptions(0), metrics: nil, views: contentViewsDictionary)
        var constraintsV2 = NSLayoutConstraint.constraintsWithVisualFormat(formatV2, options: NSLayoutFormatOptions(0), metrics: nil, views: contentViewsDictionary)
        
        // important: disable autoresizing
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        priceLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        briefLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        descLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        cell.contentView.addConstraints(constraintsH1)
        cell.contentView.addConstraints(constraintsH2)
        cell.contentView.addConstraints(constraintsH3)
        cell.contentView.addConstraints(constraintsH4)
        cell.contentView.addConstraints(constraintsV1)
        cell.contentView.addConstraints(constraintsV2)
        
        return cell
    }
    
    private func displayDestinationImage(imageView: UIImageView, imageUrl: String) {
        // load destination image at imageUrl from server
        PWImageService.loadDestinationImage(imageView, imageUrl: imageUrl) { (ok: Bool) in
            if !ok {
                // Failed loading from server, load destination image from local file
                let placeHolderFileName = PWImageService.getQuoteImagePlaceHolderFileName()
                PWImageService.loadDestinationImageFromLocalFile(imageView, imageFileName: placeHolderFileName)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected row\(indexPath.row)")
        let selectedQuote = self.fetchedResultsController.objectAtIndexPath(indexPath) as PWQuote
        
        // set the checkmark
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//            if lastSelectedCell != nil {
//                // clear the checkmark of previous selection
//                lastSelectedCell?.accessoryType = UITableViewCellAccessoryType.None
//            }
//            lastSelectedCell = cell
//            
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        onCellClick(self.request, quote: selectedQuote)
    }

    // MARK: - Navigation
    func onCellClick(request: PWRequest, quote: PWQuote) {
        println("Cell is clicked.")
        
        let quoteDetailsVC = self.storyboard!.instantiateViewControllerWithIdentifier("QuoteDetailsVC") as PWQuoteDetailsVC
        quoteDetailsVC.request = request
        quoteDetailsVC.quote = quote
        // quoteDetailsVC.delegate = self
        
        // iOS8 comptible
        self.showViewController(quoteDetailsVC as UIViewController, sender: self)
    }
    
    // MARK: - Fetched Data Controller
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        // If the fetchRequest is changed, the cache MUST be deleted frist. Otherwise, code crashes.
        let cacheName = "quoteFetchCache"
        NSFetchedResultsController.deleteCacheWithName(cacheName)
        
        let fetchController : NSFetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: self.ctx, sectionNameKeyPath: nil, cacheName: cacheName)
        fetchController.delegate = self
        _fetchedResultsController = fetchController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            println("Fetching quotes: Unresolved error \(error), \(error!.description)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    
    var fetchRequest: NSFetchRequest {
        if _fetchRequest != nil {
            return _fetchRequest!
        }
        
        // create fetchRequest instance
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = NSEntityDescription.entityForName("Quote", inManagedObjectContext: self.ctx)
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 50
        // fetchLimit controlls the total number of returned records
        //fetchRequest.fetchLimit = 200
        
        let sortByRequest = NSSortDescriptor(key: "request", ascending: true)
        fetchRequest.sortDescriptors = [sortByRequest]
        
        // ignore inactive countries
        // see WorldFacts tutorial
        // let predicate = NSPredicate(format: "%K BEGINSWITH[cd] %@", "name", "1st Item")
        let predicate = NSPredicate(format: "status != 'IGNORED' && status != 'DELETED' AND request == %@", self.request)
        fetchRequest.predicate = predicate
        
        return fetchRequest
    }
    var _fetchRequest: NSFetchRequest? = nil
}