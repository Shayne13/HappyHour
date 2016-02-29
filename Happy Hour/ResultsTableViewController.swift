//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController, UITextFieldDelegate, UISearchResultsUpdating {
  
  let client = Client.Instance.singleton
  
  var searchQueryResults = [Int]() // Deal/Venue indexes
  var searchController = UISearchController!()
  var savedSearchText: String? = ""
  
  var drinks: Bool?
  var food: Bool?
    
  @IBOutlet weak var resultsTable: UITableView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    resultsTable.backgroundColor = UIColor.grayColor()
//    tableView.estimatedRowHeight = Constants.CellDimensions.Height.Triple
//    tableView.rowHeight = UITableViewAutomaticDimension
    
    tableView.registerClass(ResultTypeCell.self, forCellReuseIdentifier: NSStringFromClass(ResultTypeCell))
    
    self.searchController = ({
      let controller = UISearchController(searchResultsController: nil)
      controller.searchResultsUpdater = self
      controller.dimsBackgroundDuringPresentation = false
      controller.hidesNavigationBarDuringPresentation = false
      controller.searchBar.sizeToFit()
      controller.searchBar.barStyle = .Black
      controller.searchBar.placeholder = "Find Your Happy Hour" // TODO: Get from client.
      // TODO:
//      controller.searchBar.prompt = "WTF"
//      controller.searchBar.tintColor =
//      controller.searchBar.barTintColor = 
      
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
    
    self.refresh()
  }
    
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.tableView.reloadData()
  }
  
  // TODO: figure out refresh mechanism (improve)
  func refresh() {
    refreshControl?.beginRefreshing()
    refresh(refreshControl)
  }
  
  @IBAction func refresh(sender: UIRefreshControl?) {
    client.fetchDeals {
      dispatch_async(dispatch_get_main_queue()) {
        self.tableView.reloadData()
        sender?.endRefreshing()
        (self.parentViewController as? ResultsViewController)?.reloadMapView()
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  // This is here to fix the open bug: - - http://www.openradar.me/22250107
  func isSearchControllerActive() -> Bool {
    return self.searchController != nil ? self.searchController.active : false
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return (isSearchControllerActive() ? 1 : client.getNumResultSections())
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (isSearchControllerActive() ? searchQueryResults.count : client.getNumResultRowsPerSection(section))
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    if (client.cellType()) { // Deal type cell:
      let dealID = (self.searchController.active ? searchQueryResults[indexPath.row] : client.getDealID(indexPath.row))
//      let cell = tableView.dequeueReusableCellWithIdentifier("ResultCellTypeOne", forIndexPath: indexPath) as! ResultCellTypeOne
      //    let cell = tableView.dequeueReusableCellWithIdentifier("ResultCellTypeTwo", forIndexPath: indexPath) as! ResultCellTypeTwo
      let cell = tableView.dequeueReusableCellWithIdentifier( NSStringFromClass(ResultTypeCell), forIndexPath: indexPath) as! ResultTypeCell
      return configureDealCell(cell, dealID: dealID)
    } else { // Venue type cell:
      let venueID = (self.searchController.active ? searchQueryResults[indexPath.row] : client.getVenueID(indexPath.row))
//      let cell = tableView.dequeueReusableCellWithIdentifier("ResultCellTypeOne", forIndexPath: indexPath) as! ResultCellTypeOne
      //    let cell = tableView.dequeueReusableCellWithIdentifier("ResultCellTypeTwo", forIndexPath: indexPath) as! ResultCellTypeTwo
      let cell = tableView.dequeueReusableCellWithIdentifier( NSStringFromClass(ResultTypeCell), forIndexPath: indexPath) as! ResultTypeCell
      return configureVenueCell(cell, venueID: venueID)
    }

  }
  
  private func configureDealCell(cell: ResultCellTypeOne, dealID: Int) -> ResultCellTypeOne
  {
    let deal = client.getDealByIndex(dealID)!
    cell.backgroundColor = UIColor.clearColor()
    cell.logo.image = client.getLogoForVenue(deal.businessID, bType: deal.bType, encodedLogoOptional: deal.logo)!
    cell.title.text = client.fullDealLabel(dealID)
    cell.header.text = deal.bName
    cell.subHeader.text = deal.address
    cell.midAnnotation.text = "" // TODO: Add something
    cell.topAnnotation.text = ""
    cell.bottomAnnotation.text = "1.8 km"
    return cell
  }
  
  private func configureDealCell(cell: ResultCellTypeTwo, dealID: Int) -> ResultCellTypeTwo
  {
    let deal = client.getDealByIndex(dealID)!
    cell.backgroundColor = UIColor.clearColor()
    cell.logo.image = client.getLogoForVenue(deal.businessID, bType: deal.bType, encodedLogoOptional: deal.logo)!
    cell.title.text = client.fullDealLabel(dealID)
    cell.header.text = deal.bName
    cell.topAnnotation.text = ""
    cell.bottomAnnotation.text = "1.8 km"
    return cell
  }
  
  private func configureVenueCell(cell: ResultCellTypeOne, venueID: Int) -> ResultCellTypeOne {
    let venue = client.getVenueByIndex(venueID)!
    cell.backgroundColor = UIColor.clearColor()
    cell.logo.image = client.getLogoForVenue(venueID, bType: venue.bType, encodedLogoOptional: venue.logo)!
    cell.title.text = venue.bName
    cell.header.text = client.fullVenueDescription(venueID, joiner: ", ")
    cell.subHeader.text = venue.address
    cell.topAnnotation.text = "" // TODO
    cell.midAnnotation.text = "" // TODO
    cell.bottomAnnotation.text = "1.8 km"
    return cell
  }
  
  private func configureVenueCell(cell: ResultCellTypeTwo, venueID: Int) -> ResultCellTypeTwo {
    let venue = client.getVenueByIndex(venueID)!
    cell.backgroundColor = UIColor.clearColor()
    cell.logo.image = client.getLogoForVenue(venueID, bType: venue.bType, encodedLogoOptional: venue.logo)!
    cell.title.text = venue.bName
    cell.header.text = venue.address
    cell.topAnnotation.text = ""
    cell.bottomAnnotation.text = "1.8 km"
    return cell
  }
  
  private func configureDealCell(cell: ResultTypeCell, dealID: Int) -> ResultTypeCell {
    cell.dealID = dealID
    return cell
  }
  
  private func configureVenueCell(cell: ResultTypeCell, venueID: Int) -> ResultTypeCell {
    cell.venueID = venueID
    return cell
  }
  
  // TODO: Finish with custom 'ResultTypeCell' ^ (start with label and image constraints / dimensions)
  // TODO: Height for Row at indexpath!

  override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat {
    return Constants.CellDimensions.Height.Triple
  }
  
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return Constants.CellDimensions.Height.Triple
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if (client.cellType()) {
      if (self.searchController.active) {
        (parentViewController as? ResultsViewController)?.selectedVenueID = client.getDealByIndex(searchQueryResults[indexPath.row])?.businessID
      } else {
        (parentViewController as? ResultsViewController)?.selectedVenueID = client.getDeal(indexPath.row).businessID
      }
    } else {
      if (self.searchController.active) {
        (parentViewController as? ResultsViewController)?.selectedVenueID = searchQueryResults[indexPath.row]
      } else {
        (parentViewController as? ResultsViewController)?.selectedVenueID = client.getVenueID(indexPath.row)
      }
    }
    (parentViewController as? ResultsViewController)?.performSegueWithIdentifier("See Detail (Table)", sender: nil)
  }
  
  // MARK: - Search
  
  func updateSearchResultsForSearchController(searchController: UISearchController)
  {
    searchQueryResults.removeAll(keepCapacity: false)
    
    let searchBarText = self.searchController.searchBar.text
    
    let searchPredicateForDeals = NSPredicate(block: { (id: AnyObject, b: [String : AnyObject]?) -> Bool in
      if let index = id as? Int {
        let venueName = self.client.getDealByIndex(index)?.bName
        if venueName!.rangeOfString(searchBarText!, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
          return true
        } else {
          return false
        }
      }
      return false
    })
    
    let searchPredicateForVenues = NSPredicate(block: { (id: AnyObject, b: [String : AnyObject]?) -> Bool in
      if let index = id as? Int {
        let venueName = self.client.getVenueByIndex(index)?.bName
        if venueName!.rangeOfString(searchBarText!, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
          return true
        }
      }
      return false
    })
    
    
    if (client.cellType())
    { // Deal type cell:
      var allDealIDs = [Int]()
      for section in 0..<client.getNumResultSections() {
        for row in 0..<client.getNumResultRowsPerSection(section) {
          allDealIDs.append(client.getDealID(row))
        }
      }
      let array = (allDealIDs as NSArray).filteredArrayUsingPredicate(searchPredicateForDeals)
      searchQueryResults = array as! [Int]
      
    } else { // Venue type cell:
      
      var allVenueIDs = [Int]()
      for section in 0..<client.getNumResultSections() {
        for row in 0..<client.getNumResultRowsPerSection(section) {
          allVenueIDs.append(client.getVenueID(row))
        }
      }
      let array = (allVenueIDs as NSArray).filteredArrayUsingPredicate(searchPredicateForVenues)
      searchQueryResults = array as! [Int]
    }
    
    self.tableView.reloadData()
  }
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

  }
  



}



//  @IBOutlet weak var mapButton: UIBarButtonItem!

//  var searchText: String? = "" {
//    didSet {
//      searchQuery?.text = searchText
//      resultsTable.reloadData() // clear out the table view
//      println(searchText)
//    }
//  }

//  @IBOutlet weak var searchQuery: UITextField! {
//    didSet {
//      searchQuery.delegate = self
//      searchQuery.text = searchText
//    }
//  }

//  func textFieldShouldReturn(textField: UITextField) -> Bool {
//    if textField == searchQuery {
//      textField.resignFirstResponder()
//      searchText = textField.text
//    }
//    return true
//  }

// CELL IMAGE STUFF:

//    var upArrow = UIImage(named: "arrowU")
//    var downArrow = UIImage(named: "arrowD")
//
//    let upSize = CGSizeApplyAffineTransform(upArrow!.size, CGAffineTransformMakeScale(0.05, 0.05))
//    let hasAlpha = false
//    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
//    UIGraphicsBeginImageContextWithOptions(upSize, !hasAlpha, scale)
//    upArrow!.drawInRect(CGRect(origin: CGPointZero, size: upSize))
//    let upScaledImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()

//    let downSize = CGSizeApplyAffineTransform(downArrow!.size, CGAffineTransformMakeScale(0.05, 0.05))
////    let hasAlpha = false
////    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
//    UIGraphicsBeginImageContextWithOptions(downSize, !hasAlpha, scale)
//    upArrow!.drawInRect(CGRect(origin: CGPointZero, size: downSize))
//    let downScaledImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//
//
//    cell.upVoteButton.contentMode = .ScaleAspectFit
//    cell.upVoteButton.image = upScaledImage
//
//
//    cell.downVoteButton.contentMode = .ScaleAspectFit
//    cell.downVoteButton.image = downScaledImage



//    var originalWidth  = image.size.width
//    var originalHeight = image.size.height
//
//    var edge: CGFloat
//    if originalWidth > originalHeight {
//      edge = originalHeight
//    } else {
//      edge = originalWidth
//    }
//
//    var posX = (originalWidth  - edge) / 2.0
//    var posY = (originalHeight - edge) / 2.0
//
//    var cropSquare = CGRectMake(posX, posY, edge, edge)
//
//    var imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
//    return UIImage(CGImage: imageRef, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
