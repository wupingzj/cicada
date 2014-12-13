//
//  PWDestinationTableVC.swift
//  cicada
//
//  Created by Ping on 1/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit

class PWDestinationTableVC: UITableViewController, UISearchBarDelegate {
//    var tableData: [String] = ["One1","Two1", "Three1", "One2","Two2", "Three2", "One3","Two3", "Three3", "One4","Two", "Three", "One5","Two", "Three", "One3","Two", "Three", "One","Two", "Three", "One","Two", "Three", "One","Two", "Three", "One4","Two", "Three", "One","Two", "Three", "One","Two", "Three", "One","Two", "Three", "One5","Two", "Three", "One","Two", "Three", "One","Two", "Three", "One","Two", "Three"]
    var searchResult: [String] =  [String]()
    
    
    var tableData: Dictionary<String, [String]> = ["B":["bear", "bee"], "C":["cat","cow"], "D":["Dog"], "E":["Emu"], "F":["frog"], "H":["horse"], "Y":["yak"]]
    
    var sectionTitles: [String] = [String]()
    
    @IBOutlet var infoView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    
    var isFiltered: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        //addMySeparatorLine()
        
        sectionTitles = tableData.keys.array
        sectionTitles.sort() {$0 < $1}
    }
    
    func addMySeparatorLine() {
        let lineView = UIView(frame: CGRectMake(0, 50, 200, 1))
        lineView.backgroundColor = UIColor.blackColor()
        infoView.addSubview(lineView)
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isFiltered) {
            // TODO
            return searchResult.count
        } else {
            //return tableData.count
            let sectionTitle: String = sectionTitles[section]
            let a: [String]? = tableData[sectionTitle]
            if a == nil {
                return 0
            } else {
                return a!.count
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("destinationCell", forIndexPath: indexPath) as UITableViewCell
        
        if (isFiltered) {
            // TODO
            cell.textLabel!.text = searchResult[indexPath.row]
        } else {
            //cell.textLabel!.text = tableData[indexPath.row]
            
            //return tableData.count
            var text = ""
            let sectionTitle: String = sectionTitles[indexPath.section]
            let a: [String]? = tableData[sectionTitle]
            if a == nil {
                text = "Not Found"
            } else {
                text = a![indexPath.row]
            }
            
            cell.textLabel!.text = text
        }
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
//        <#code#>
//    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitles[section]
    }
    
    // show Section Index Titles
    // ref: http://www.appcoda.com/ios-programming-index-list-uitableview/
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return sectionTitles
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let len = countElements(searchText)
        if (len == 0) {
            isFiltered = false
        } else {
            isFiltered = true
        }
        
        self.filterContentForSearchText(searchText)
        
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked() {
        // When clicked the search button, dismiss the keyboard
        self.searchBar.resignFirstResponder()
    }
    
    func filterContentForSearchText(searchText: NSString) {
        
        
        /*searchResult = tableData.filter() {(m: String) -> Bool in
        return m.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil
        }*/
        
//        searchResult = tableData.filter() {
//            $0.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil
//        }
        
        println("searchText=\(searchText)     searchResult.count=\(searchResult.count)")
        
        // to use NSPredicate, followint this torial
        // http://blog.mugunthkumar.com/coding/iphone-tutorial-uisearchdisplaycontroller-with-nspredicate/
    }

}
