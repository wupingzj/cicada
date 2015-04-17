//
//  PWRequestTableVC.swift
//  cicada
//
//  Created by Ping on 15/03/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class PWRequestTableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    var lastSelectedCell: UITableViewCell? = nil
    var ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellID = "RequestTableCell"
        let nibName = cellID
        self.tableView.registerNib(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: cellID)
//        self.tableView.registerClass(PWRequestTVCell.self, forCellReuseIdentifier: cellID)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh table
    func reloadTableView() {
        // reset fetchResultController to reflect the data change
        _fetchedResultsController = nil
        self.tableView.reloadData()
    }
    
    func refresh() {
        // TODO
        self.reloadTableView()
        self.refreshControl!.endRefreshing()
        return
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            println("sections.count=\(sections.count)")
            return sections.count
        } else {
            println("ERROR@PWRequestTableVC: No sections found!")
            return 0
        }
//            return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            let sectionInfo = sections[section] as NSFetchedResultsSectionInfo
            println("Total \(sectionInfo.numberOfObjects) rows")
            return sectionInfo.numberOfObjects
        } else {
            println("ERROR@PWRequestTableVC: No sections found!")
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "RequestTableCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier("requestCell", forIndexPath: indexPath) as UITableViewCell
//        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as PWRequestTVCell

        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }

    func configureCell(cell:UITableViewCell, atIndexPath indexPath:NSIndexPath) {
        let request:PWRequest = self.fetchedResultsController.objectAtIndexPath(indexPath) as PWRequest
        if let textLabel = cell.textLabel {
            cell.textLabel!.text = request.destination.toDisplayString()
            cell.detailTextLabel!.text = request.getPeriodStr()
        } else {
            println("ERROR@PWRequestTableVC: No text label found!")
        }
    }
    

    // Customize the appearance of table view cells.
    func configureCell2(cell:PWRequestTVCell, atIndexPath indexPath:NSIndexPath) {
        let request:PWRequest = self.fetchedResultsController.objectAtIndexPath(indexPath) as PWRequest
        
        cell.destinationLabel.text = request.destination.toDisplayString()
        cell.periodLabel.text = request.getPeriodStr()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRequest = self.fetchedResultsController.objectAtIndexPath(indexPath) as PWRequest
        
        // set the checkmark
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if lastSelectedCell != nil {
                // clear the checkmark of previous selection
                lastSelectedCell?.accessoryType = UITableViewCellAccessoryType.None
            }
            lastSelectedCell = cell
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        
        
//        let selectedCountry:Country = self.fetchedResultsController.objectAtIndexPath(indexPath) as Country
//        
//        // set the checkmark
//        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//            if lastSelectedCell != nil {
//                // clear the checkmark of previous selection
//                lastSelectedCell?.accessoryType = UITableViewCellAccessoryType.None
//            }
//            lastSelectedCell = cell
//            
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//        }
//        
//        // callback the delegate
//        if delegate != nil {
//            delegate!.didSelectCountry(self, selectedCountry: selectedCountry)
//        }
//        
//        // programmatically click the Back button
//        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showQuotesSeque" {
            let indexPath: NSIndexPath? = self.tableView.indexPathForSelectedRow()
            
            if (indexPath == nil) {
                println("*** ERROR: MUST SELECT A business entity to proceed...***")
            } else {
                let destinationTableVC: PWQuoteTableVC = segue.destinationViewController as PWQuoteTableVC
                let request:PWRequest = self.fetchedResultsController.objectAtIndexPath(indexPath!) as PWRequest
                destinationTableVC.request = request
            }
        } else {
            println("Unsupported segue \(segue.identifier)")
        }
    }
    
    // MARK: - Fetched Data Controller
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        // If the fetchRequest is changed, the cache MUST be deleted frist. Otherwise, code crashes.
        let cacheName = "requestFetchCache"
        NSFetchedResultsController.deleteCacheWithName(cacheName)
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
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
        
        fetchRequest.entity = NSEntityDescription.entityForName(PWRequest.getEntityName(), inManagedObjectContext: self.ctx)
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 50
        // fetchLimit controlls the total number of returned records
        //fetchRequest.fetchLimit = 200
        
        let sortByRequest = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortByRequest]

        // ignore deleted requests
        let predicate = NSPredicate(format: "status != 'DELETED'")
        fetchRequest.predicate = predicate

        return fetchRequest
    }
    var _fetchRequest: NSFetchRequest? = nil
}


// Tech memo:
//      To use custom TableViewCell,
//          a. create cell class
//          b. create cell nib file
//          c. self.tableView.registerNib(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: cellID)
//                  Don't registerClass as that doesn't use Nib
//          d. let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as PWRequestTVCell
//