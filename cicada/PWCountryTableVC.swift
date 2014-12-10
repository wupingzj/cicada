//
//  PWCountryTableVC.swift
//  cicada
//
//  Created by Ping on 9/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit
import CoreData

class PWCountryTableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    var ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = self.fetchedResultsController.sections {
            let sectionInfo = sections[section] as NSFetchedResultsSectionInfo
            return sectionInfo.numberOfObjects
        } else {
            println("ERROR@FavoriteTableVC: No sections found!")
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */


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
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let fetchController : NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.ctx, sectionNameKeyPath: "name", cacheName: "Master")
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
    
    
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection sectionIdx:NSInteger) -> String {
//        if let sections = self.fetchedResultsController.sections {
//            let sectionInfo = sections[sectionIdx] as NSFetchedResultsSectionInfo
//            return sectionInfo.name
//        } else {
//            println("ERROR@SeekTableVC: No sections found!")
//            return "N/A"
//        }
//    }
    
    // --- might not be used
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case NSFetchedResultsChangeType.Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case NSFetchedResultsChangeType.Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            // Move
            // Update
            // @TODO please handle move and update events
            println("****** section is being changed. Please handle it.")
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case NSFetchedResultsChangeType.Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath)!, atIndexPath: indexPath)
        case NSFetchedResultsChangeType.Move:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
