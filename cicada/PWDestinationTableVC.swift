//
//  PWDestinationTableVC.swift
//  cicada
//
//  Created by Ping on 1/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit
import CoreData

protocol PWDestinationTableVCDelegate {
    func didSelectDestination(controller: PWDestinationTableVC, selectedDestination: PWDestination)
}

enum PWDestinationSearchScope: Int {
    case Contain = 0
    case BeginWith = 1
}

// NOTE: Because this TableVC actually contains two table views: self.tableview and the tableview for SearchBar, caution must be taken to use correct table view!
// The self.tableview and the tableview parameter in methods are different!
// Please see sample application WordFacts

class PWDestinationTableVC: UITableViewController, NSFetchedResultsControllerDelegate, UISearchDisplayDelegate {
    // No need to implement UISearchBarDelegate. Instead, UISearchDisplayDelegate is implemented
    var delegate: PWDestinationTableVCDelegate? = nil
    var ctx: NSManagedObjectContext = DataService.sharedInstance.getContext()
    var country: Country!

    var filteredList: [PWDestination] =  [PWDestination]()
    var lastSelectedCell: UITableViewCell? = nil
    var isFiltered: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        sectionTitles = tableData.keys.array
//        sectionTitles.sort() {$0 < $1}
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (tableView == self.tableView) {
            
            
            let count = self.fetchedResultsController.sections?.count ?? 0
            println("The total number of sections=\(count)")
            return count
        } else {
            return 1;
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if !isFiltered {
        if (tableView == self.tableView) {
            let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
            return sectionInfo.numberOfObjects
        } else {
            return self.filteredList.count;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let originalTableView = self.tableView
        // Don't use method parameter tableView as the cell is not registered with searchBar
//        let cell = originalTableView.dequeueReusableCellWithIdentifier("destinationCell", forIndexPath: indexPath) as UITableViewCell
        
        let cell = originalTableView.dequeueReusableCellWithIdentifier("destinationCell") as UITableViewCell
        
        var destination: PWDestination!
        if (tableView == self.tableView) {
            destination = self.fetchedResultsController.objectAtIndexPath(indexPath) as PWDestination
        } else {
            destination = self.filteredList[indexPath.row]
        }
        
        var text: String!
        if let town = destination.town {
            text = "  " + town + ", " + destination.city
        } else {
            text = "  " + destination.city
        }
        
        cell.textLabel?.text = text
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedDestination: PWDestination? = nil;
        if (self.searchDisplayController!.active) {
            selectedDestination = self.filteredList[indexPath.row]
        } else {
            selectedDestination = self.fetchedResultsController.objectAtIndexPath(indexPath) as? PWDestination
        }
        
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
        if delegate != nil && selectedDestination != nil {
            delegate!.didSelectDestination(self, selectedDestination: selectedDestination!)
        }

//        if (self.searchDisplayController!.active) {
//            // programmatically click the Cancel button of search bar
//            self.searchDisplayController!.active = false
//        }
        
        // programmatically click the Back button
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Title
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //        if !country.useState {
        //            // Only show section when country uses state
        //            return nil
        //        }
        
        if (tableView == self.tableView) {
            let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
            return sectionInfo.name
        } else {
            return nil;
        }
    }
    
    // show Section Index Titles
    // ref: http://www.appcoda.com/ios-programming-index-list-uitableview/
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        if (tableView == self.tableView) {
            var index: [AnyObject] = [UITableViewIndexSearch]
            var initials = self.fetchedResultsController.sectionIndexTitles
            index += initials
            return index;
        } else {
            return nil;
        }
    }

    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if (tableView == self.tableView) {
            if (index > 0) {
                // The index is offset by one to allow for the extra search icon inserted at the front
                // of the index
                
                return self.fetchedResultsController.sectionForSectionIndexTitle(title, atIndex:index-1)
            } else {
                // The first entry in the index is for the search icon so we return section not found
                // and force the table to scroll to the top.
                
                self.tableView.contentOffset = CGPointZero;
                return NSNotFound;
            }
        } else {
            return 0;
        }
    }
    
    // MARK: - Search
    func searchForText(searchText: String, scope: PWDestinationSearchScope) -> Bool {
        var predicate: NSPredicate!
        var searchAttribute: String!
        var predicateFormat: String!
        
        searchAttribute = "city"
        
        if scope == PWDestinationSearchScope.BeginWith {
            predicateFormat = "country == %@ and (town BEGINSWITH[cd] %@ or city BEGINSWITH[cd] %@)"
        } else if scope == PWDestinationSearchScope.Contain {
            predicateFormat = "country == %@ and (town contains[cd] %@ or city contains[cd] %@)"
        } else {
            return false
        }

        predicate = NSPredicate(format: predicateFormat, self.country, searchText, searchText)
        self.fetchRequest.predicate = predicate
        
        var error: NSError? = nil
        self.filteredList = self.ctx.executeFetchRequest(self.fetchRequest, error: &error) as [PWDestination]

        if error != nil {
            println("searchForText failed:\(error?.localizedDescription)")
            return false
        } else {
            return true
        }
    }
    
    // MARK: - UISearchDisplayDelegate
    // TODO -------- UISearchDisplayDelegate is deprecated. Use UISearchController instead
    // http://stackoverflow.com/questions/25826332/searchdisplaycontroller-deprecated-ios-8
    // http://stackoverflow.com/questions/24910350/uisearchdisplaydelegate-deprecation-work-around
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        return search(controller.searchBar)
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        return search(controller.searchBar)
    }
    
    private func search(searchBar: UISearchBar) -> Bool {
        let rawScope = searchBar.selectedScopeButtonIndex
        let searchString = searchBar.text
        
        if let scope = PWDestinationSearchScope.fromRaw(rawScope) {
            if searchString.isEmpty {
                return false
            } else {
                return searchForText(searchString!, scope: scope)
            }
        } else {
            return false
        }
    }

    // MARK: - Fetched Results Controller
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        var sectionNameKeyPath: String? = nil
        if country.useState {
            sectionNameKeyPath = "state"
        } else {
            sectionNameKeyPath = "city"
        }

        // NSFetchedResultsController.deleteCacheWithName("CacheName")
        let fetchController : NSFetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: self.ctx, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        fetchController.delegate = self
        _fetchedResultsController = fetchController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            println("Fetching countries: Unresolved error \(error), \(error!.userInfo)")
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
        
        fetchRequest.entity = NSEntityDescription.entityForName("Destination", inManagedObjectContext: self.ctx)
        
        fetchRequest.fetchBatchSize = 50
        // fetchLimit controlls the total number of returned records
        //fetchRequest.fetchLimit = 200
        
        let sortByState = NSSortDescriptor(key: "state", ascending: true)
        let sortByCity = NSSortDescriptor(key: "city", ascending: true)
        let sortByTown = NSSortDescriptor(key: "town", ascending: true)
        let sortByDisplayOrder = NSSortDescriptor(key: "displayOrder", ascending: true)
        let sortByPostCode = NSSortDescriptor(key: "postCode", ascending: true)
        fetchRequest.sortDescriptors = [sortByDisplayOrder, sortByState, sortByCity, sortByTown]
        
        // see WorldFacts tutorial
        // let predicate = NSPredicate(format: "%K BEGINSWITH[cd] %@", "name", "1st Item")
        let predicate = NSPredicate(format: "country == %@", self.country)
        fetchRequest.predicate = predicate
        
        _fetchRequest = fetchRequest
            
        return fetchRequest
    }
    var _fetchRequest: NSFetchRequest? = nil
}
