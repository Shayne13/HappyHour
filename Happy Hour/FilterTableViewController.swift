//
//  FilterTableViewController.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 7/7/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

  let client = Client.Instance.singleton
  
  private var sortTypeCell: SortControllerCell? = nil
  private var currentlyOpenCell: CurrentlyOpenToggleCell? = nil
  private var resultTypeCell: ResultTypeControllerCell? = nil
  private var headerButtonCell: HeaderButtonCell? = nil
  private var numActiveConstraints: Int {
    get {
      return (resultType ? toggledDealCategories.count : toggledBusinessClasses.count)
    }
  }
  
  // Sets of toggled categories/classes to compare after 'Done' is pressed:
  private var originalToggledDealCategories = Set<Int>()
  private var originalToggledBusinessClasses = Set<Int>()
  private var toggledDealCategories = Set<Int>()
  private var toggledBusinessClasses = Set<Int>()
  
  private var originalResultType = Bool()
  private var resultType: Bool {
    get {
      return (resultTypeCell?.resultTypeController.selectedSegmentIndex == 0 ? true : false)
    }
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    originalResultType = Defaults.getCellType()
    originalToggledDealCategories = Defaults.getToggledDealCategories()
    originalToggledBusinessClasses = Defaults.getToggledBusinessClasses()
    toggledDealCategories = Defaults.getToggledDealCategories()
    toggledBusinessClasses = Defaults.getToggledBusinessClasses()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancel"))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("done"))
    navigationItem.title = "Sort and Filter"
    navigationController?.navigationBar.tintColor =  UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0)
    
  }

  private struct Storyboard
  {
    static let SortHeader = "Sort by"
    static let FilterHeader = "Filter by"
    static let ResultTypeHeader = "See Results as"
    static let CategoryHeaderDeals = "Limit Deals to"
    static let CategoryHeaderVenue = "Limit Venues to"
    static let DealCurrentlyOpen = "Currently Available"
    static let VenueCurrentlyOpen = "Currently Open"
    
    struct CellIdentifier
    {
      static let SortType = "SortTypeSelectionCell"
      static let CurrentlyOpen = "CurrentlyOpenToggleCell"
      static let FeatureTypes = "FeatureTypeSelectionCell"
      static let CellType = "CellTypeSelectionCell"
      static let FilterOption = "FilterOptionCell"
      static let HeaderButtonCell = "HeaderButtonCell"
    }
  }
  
  @IBAction func changeResultCellType(sender: UISegmentedControl) {
    tableView.reloadData()
  }
  
  func resetFilterClasses() {
    if (resultType)
    {
      let toggledCells = toggledDealCategories
      for index in toggledCells {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index - 1, inSection: 2))
        cell?.accessoryType = .None
      }
      toggledDealCategories.removeAll()
    } else {
      let toggledCells = toggledBusinessClasses
      for index in toggledCells {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index - 1, inSection: 2))
        cell?.accessoryType = .None
      }
      toggledBusinessClasses.removeAll()
    }
  }
  
  
  func cancel() { // Don't save any changes to defaults
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func done()
  {
//    if (sortTypeCell!.didChangeSortType()) {
//      Defaults.setSortType((sortTypeCell?.sortTypeController?.selectedSegmentIndex)!)
//    }
    
    if (currentlyOpenCell!.didToggleSwitch()) {
      Defaults.setCurrentlyOpenStatus((currentlyOpenCell?.currentlyOpenSwitch?.on)!)
    }
    
    if (resultType != originalResultType) {
      Defaults.setCellType(resultType)
    }
    
    if (originalToggledDealCategories != toggledDealCategories) {
      Defaults.setDealCategories(toggledDealCategories)
    }
    
    if (originalToggledBusinessClasses != toggledBusinessClasses) {
      Defaults.setBusinessClasses(toggledBusinessClasses)
    }
    
    // TODO: With Sorting Enabled:
//    if (resultSortRequired()) {
//      client.sortResults(false)               // Sorts and filters
//    } else if (resultFilterRequired()) {
//      client.filterResults(true)             // Just filters
//    }
    
    if (resultFilterRequired()) { client.filterResults(true) }
    
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func resultFilterRequired() -> Bool
  {
    if (currentlyOpenCell!.didToggleSwitch()) { return true }
    
    if ((resultType) && (originalToggledDealCategories != toggledDealCategories)) { return true }
    
    if ((!resultType) && (originalToggledBusinessClasses != toggledBusinessClasses)) { return true }
    
    return false
  }
  
  func resultSortRequired() -> Bool
  {
    if ((sortTypeCell!.didChangeSortType()) || (resultType != originalResultType)) { return true }

    return false
  }
  
  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    switch (section)
    {
    case 0:
      return 1
    case 1:
      return 1
    case 2:
      return (client.cellType() ? client.DealCategories.count : client.BusinessClasses.count)
    default:
      return 0
    }
  }

  // TODO: Change fonts, cell sizes, header text and colors and then add button (then centralize sizes/colors)
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    let cellHeight: CGFloat = 30.0
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: cellHeight))
    view.backgroundColor = UIColor.grayColor()
    
    let label = UILabel(frame: CGRect(x: 5, y: 0, width: tableView.frame.size.width/2, height: cellHeight))
    label.textColor = UIColor.whiteColor()
    label.font = UIFont(name: "Helvetica-Neue", size: 16)
    
    if (section == 1) {
      label.text = "Result Types"
      view.addSubview(label)
    }
    
    if (section == 2) {
      
      label.text = "Limit Deals to"
      
      let resetButton: UIButton = UIButton(type: UIButtonType.System)
      resetButton.frame = CGRect(x: tableView.frame.size.width - 60, y: 0, width: 60, height: cellHeight)
      resetButton.backgroundColor = UIColor.cyanColor()
      let textAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!]
      let resetButtonTitle = NSAttributedString(string: "Reset", attributes: textAttributes)
      resetButton.setAttributedTitle(resetButtonTitle, forState: UIControlState.Normal)
      resetButton.addTarget(self, action: "resetFilterClasses", forControlEvents: UIControlEvents.TouchUpInside)
      
      view.addSubview(label)
      view.addSubview(resetButton)
      
    }

    return view
  }
  
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch(section) {
    case 0:
      return 0
    case 1:
      return 30 //Storyboard.CellDimensions.StyleHeaderHeight
    case 2:
      return 30 //Storyboard.CellDimensions.HeaderHeight
    default:
      return 30 //Storyboard.CellDimensions.HeaderHeight
    }
  }
  
//  override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat
//  {
//    if (indexPath.section == 0)
//    {
//      return CGFloat(Storyboard.CellDimensions.SectionZeroCellHeights[indexPath.row])
//    } else if (indexPath.section == 1) {
//      return tableView.rowHeight
//    } else {
//      return Storyboard.CellDimensions.DealSectionCellHeight
//    }
//  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    if (indexPath.section == 0)
    {
      currentlyOpenCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier.CurrentlyOpen, forIndexPath: indexPath) as? CurrentlyOpenToggleCell
      currentlyOpenCell?.currentlyOpenLabel.text = (resultType ? Storyboard.DealCurrentlyOpen : Storyboard.VenueCurrentlyOpen)
      return currentlyOpenCell!
    } else if (indexPath.section == 1) {
      resultTypeCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier.CellType, forIndexPath: indexPath) as? ResultTypeControllerCell
      return resultTypeCell!
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier.FilterOption, forIndexPath: indexPath) as! FilterCheckBoxCell
      if (resultType) // Deal Cell
      {
        cell.title.text = client.DealCategories[indexPath.row + 1]
        cell.accessoryType = (toggledDealCategories.contains(indexPath.row + 1) ? .Checkmark : .None)
      } else {
        cell.title.text = client.BusinessClasses[indexPath.row + 1]
        cell.accessoryType = (toggledBusinessClasses.contains(indexPath.row + 1) ? .Checkmark : .None)
      }
      return cell
    }
  }
  
  // Toggle the cell's checkmark, and set it's new status in the underlying status list.
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    if (indexPath.section == 2)
    {
      let cell = tableView.cellForRowAtIndexPath(indexPath)
      cell?.accessoryType = (cell?.accessoryType == .Checkmark ? .None : .Checkmark)
      if (resultType)
      {
        if toggledDealCategories.contains(indexPath.row + 1) { // TODO: Make extension for set to do this if/else operation
          toggledDealCategories.remove(indexPath.row + 1)
        } else {
          toggledDealCategories.insert(indexPath.row + 1)
        }
      } else {
        if toggledBusinessClasses.contains(indexPath.row + 1) {
          toggledBusinessClasses.remove(indexPath.row + 1)
        } else {
          toggledBusinessClasses.insert(indexPath.row + 1)
        }
      }
    }
//    resetHeaderButtonTitle()
  }
  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return NO if you do not want the specified item to be editable.
      return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
          // Delete the row from the data source
          tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      } else if editingStyle == .Insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }    
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return NO if you do not want the item to be re-orderable.
      return true
  }
  */

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using [segue destinationViewController].
      // Pass the selected object to the new view controller.
  }
  */

}

// HEADER SUBVIEW (SEGMENTED CONTROLLER):

//override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//  let frameWidth = UIScreen.mainScreen().bounds.width
//  let headerView = UIView(frame: CGRect(x: 0, y: 20, width: frameWidth, height: 100))
//  var cellTypeSegmentedController = UISegmentedControl(items: ["Deals", "Venues"])
//  cellTypeSegmentedController.addTarget(self, action: "changeCellType:", forControlEvents: .ValueChanged)
//  cellTypeSegmentedController.backgroundColor = UIColor.blackColor()
//  cellTypeSegmentedController.tintColor = UIColor.whiteColor()
//  cellTypeSegmentedController.selectedSegmentIndex = 0
//  cellTypeSegmentedController.frame = CGRect(x: 0, y: 20, width: frameWidth, height: 70)
//  headerView.addSubview(cellTypeSegmentedController)
//  return cellTypeSegmentedController
//}

