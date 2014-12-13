//
//  PWCountryTableVC.swift
//  cicada
//
//  Created by Ping on 9/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit
import CoreData

protocol PWCountryTableVCDelegate {
    func didSelectCountry(controller: PWCountryTableVC, selectedCountry: Country)
}

class PWCountryTableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    var delegate: PWCountryTableVCDelegate? = nil
    var country: Country!
    
    var lastSelectedCell: UITableViewCell? = nil
    var ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        } else {
            println("ERROR@PWCountryTableVC: No sections found!")
            return 0
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = self.fetchedResultsController.sections {
            let sectionInfo = sections[section] as NSFetchedResultsSectionInfo
            return sectionInfo.numberOfObjects
        } else {
            println("ERROR@PWCountryTableVC: No sections found!")
            return 0
        }
    }

    // Customize the appearance of table view cells.
    func configureCell(cell:UITableViewCell, atIndexPath indexPath:NSIndexPath) {
        let country:Country = self.fetchedResultsController.objectAtIndexPath(indexPath) as Country
        if let textLabel = cell.textLabel {
            cell.textLabel!.text = country.name
        } else {
            println("ERROR@SeekTableVC: No text label found!")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countryCell", forIndexPath: indexPath) as UITableViewCell

        self.configureCell(cell, atIndexPath: indexPath)

        return cell
    }
    
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCountry:Country = self.fetchedResultsController.objectAtIndexPath(indexPath) as Country

        // set the checkmark
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if lastSelectedCell != nil {
                // clear the checkmark of previous selection
                lastSelectedCell?.accessoryType = UITableViewCellAccessoryType.None
            }
            lastSelectedCell = cell

            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    
        // callback the delegate
        if delegate != nil {
            delegate!.didSelectCountry(self, selectedCountry: selectedCountry)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK - fetch data
    // #pragma mark - Fetched results controller
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
            
        let fetchRequest = NSFetchRequest()

        fetchRequest.entity = NSEntityDescription.entityForName("Country", inManagedObjectContext: self.ctx)
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 50
        // fetchLimit controlls the total number of returned records
        //fetchRequest.fetchLimit = 2
        
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortByName]
            
        // TODO -- filter inactive countries like India
        // see WorldFacts tutorial
//      let predicate = NSPredicate(precondition({}, {return "Message To Be Defined"}))
//        let predicate = NSPredicate(format: "%K BEGINSWITH[cd] %@", "1st Item")
        let predicate = NSPredicate(format: "active == YES")
        fetchRequest.predicate = predicate
            
        // If the fetchRequest is changed, the cache MUST be deleted. Otherwise, code crashes.
//        NSFetchedResultsController.deleteCacheWithName("Master")

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let fetchController : NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.ctx, sectionNameKeyPath: "name", cacheName: nil)
        fetchController.delegate = self
        _fetchedResultsController = fetchController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            println("Unresolved error \(error), \(error!.description)")
            //abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
}
