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
    var quote: PWQuote!
    
    var lastSelectedCell: UITableViewCell? = nil
    var ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
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
    
    // Customize the appearance of table view cells.
    func configureCell(cell:UITableViewCell, atIndexPath indexPath:NSIndexPath) {
        let quote:PWQuote = self.fetchedResultsController.objectAtIndexPath(indexPath) as PWQuote
        if let textLabel = cell.textLabel {
            cell.textLabel!.text = "TODO: Quote Description" + quote.uuid
        } else {
            println("ERROR@SeekTableVC: No text label found!")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("quoteCell", forIndexPath: indexPath) as UITableViewCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedQuote = self.fetchedResultsController.objectAtIndexPath(indexPath) as PWQuote
        
        // set the checkmark
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if lastSelectedCell != nil {
                // clear the checkmark of previous selection
                lastSelectedCell?.accessoryType = UITableViewCellAccessoryType.None
            }
            lastSelectedCell = cell
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }
    
    // MARK: - Fetched Data Controller
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        // If the fetchRequest is changed, the cache MUST be deleted frist. Otherwise, code crashes.
        let cacheName = "quoteFetchCache"
        NSFetchedResultsController.deleteCacheWithName(cacheName)
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        
        // TODO: give it a cache name to enable fetch Requet Cache
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
        let predicate = NSPredicate(format: "status == 'IGNORED'")
        fetchRequest.predicate = predicate
        
        return fetchRequest
    }
    var _fetchRequest: NSFetchRequest? = nil
}