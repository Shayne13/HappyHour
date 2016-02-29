//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController, UISearchResultsUpdating { //, UISearchBarDelegate {

  let client = Client.Instance.singleton
  
  @IBOutlet weak var locationTable: UITableView!
  var searchFilteredLocations = [Int]()
  var searchController = UISearchController!()
//  var searchController: UISearchController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationTable.backgroundColor = UIColor.grayColor()
    tableView.estimatedRowHeight = tableView.rowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // TODO: Customize Cancel button
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancel"))
    self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 124/255, green: 201/255, blue: 224/255, alpha: 1.0)
    self.navigationItem.title = "Set Location"
    
    self.searchController = ({
      let controller = UISearchController(searchResultsController: nil)
      controller.searchResultsUpdater = self
//      controller.searchBar.delegate = self
      controller.dimsBackgroundDuringPresentation = false
      controller.searchBar.sizeToFit()
      controller.searchBar.placeholder = "Search Locations"
      self.tableView.tableHeaderView = controller.searchBar

      return controller
    })()

    // This is here to fix the open bug: - http://www.openradar.me/22250107
    if #available(iOS 9.0, *) {
        self.searchController.loadViewIfNeeded()
    } else {
        // Fallback on earlier versions
      let _ = self.searchController.view          // iOS 8
    }
    
    self.tableView.reloadData()
  }
  

  func cancel() {
    self.searchController.active = false
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }

  // MARK: - Table view data source

  // This is here to fix the open bug: - - http://www.openradar.me/22250107
  func isSearchControllerActive() -> Bool {
    return self.searchController != nil ? self.searchController.active : false
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return (isSearchControllerActive() ? 1 : client.getNumLocationSections())
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (isSearchControllerActive() ? self.searchFilteredLocations.count : client.getNumLocationRowsPerSection(section))
  }

  override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
    header.textLabel!.textColor = UIColor.whiteColor() //make the text white
    header.textLabel!.textAlignment = .Right
    header.contentView.backgroundColor = UIColor(red: 0/255, green: 181/255, blue: 229/255, alpha: 0.8) //make the background color light blue
  }
  
  private struct Storyboard {
    static let cityLocationCellIdentifier = "CityLocationCell"
    static let DistrictLocationCellIdentifier = "DistrictLocationCell"
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if (self.searchController.active) {
      let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.DistrictLocationCellIdentifier, forIndexPath: indexPath) 
      let location = client.getLocationByIndex(searchFilteredLocations[indexPath.row])
      cell.backgroundColor = UIColor.clearColor()
      cell.textLabel?.textColor = UIColor.whiteColor()
      cell.textLabel?.text = location!.name
      return cell
    }
    
    let location = client.getLocation(indexPath)
    if location.sub == 0 { // location is a city (no parent):
      
      let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cityLocationCellIdentifier, forIndexPath: indexPath) 
      
      cell.backgroundColor = UIColor.clearColor()
      cell.textLabel?.textColor = UIColor(red: 0/255, green: 181/255, blue: 229/255, alpha: 1.0)
      cell.textLabel?.text = location.name
      cell.textLabel?.textAlignment = .Left
      
      return cell
      
    } else { // location is a district (has a parent):
      
      let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.DistrictLocationCellIdentifier, forIndexPath: indexPath) 
      
      cell.backgroundColor = UIColor.clearColor()
      cell.textLabel?.textColor = UIColor.whiteColor()
      cell.textLabel?.text = "   " + location.name
      cell.textLabel?.textAlignment = .Left
      
      return cell
    }
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return (isSearchControllerActive() ? nil : client.getStateSectionHeader(section))
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if (isSearchControllerActive()) {
      let selectedLocation = client.getLocationByIndex(searchFilteredLocations[indexPath.row])!
      client.selectedLocation = selectedLocation
    } else {
      let selectedLocation = client.getLocation(indexPath)
      client.selectedLocation = selectedLocation
    }
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func updateSearchResultsForSearchController(searchController: UISearchController)
  {
    searchFilteredLocations.removeAll(keepCapacity: false)
    
    let searchBarText = self.searchController.searchBar.text
    
    let searchPredicate = NSPredicate(block: { (locID: AnyObject, b: [String : AnyObject]?) -> Bool in
      if locID is NSNumber {
        let id = locID as! Int
        let locName = self.client.getLocationByIndex(id)!.name
        if locName.rangeOfString(searchBarText!, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
          return true
        } else {
          return false
        }
      }
      return false
    }) // TODO: Optimize predicate logic: BeginsWith then Contains appended (2 predicates) instead of straight contains.
    
  
//    let searchPredicate = NSPredicate(format: "CONTAINS[c] %@", searchController.searchBar.text)
//    let searchPredicate = NSPredicate(block: (locID: AnyObject!, b: ))
    var allLocationIDs = [Int]()
    for section in 0..<client.getNumLocationSections() {
      for row in 0..<client.getNumLocationRowsPerSection(section) {
        let indexPath = NSIndexPath(forRow: row, inSection: section)
        allLocationIDs.append(client.getLocation(indexPath).cityID)
      }
    }
    let array = (allLocationIDs as NSArray).filteredArrayUsingPredicate(searchPredicate)
    searchFilteredLocations = array as! [Int]
    
    self.tableView.reloadData()
  }


}
