//
//  ResultsViewController.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 6/29/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

  let client = Client.Instance.singleton
  
  @IBOutlet weak var rtvc: ResultsTableViewController!
  @IBOutlet weak var rmvc: ResultsMapViewController!
  
  @IBOutlet weak var toggleView: UISegmentedControl!
  @IBOutlet weak var listViewContainer: UIView!
  @IBOutlet weak var mapViewContainer: UIView!
  
  var selectedVenueID: Int? = nil
  
  var venueAnnotation: VenueMKAnnotation? = nil
  var viewType: String = "List"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavBar()
    
    mapViewContainer.hidden = true
    listViewContainer.hidden = false
    rmvc = (childViewControllers.last?.contentViewController as? ResultsMapViewController)!
    rtvc = (childViewControllers.first?.contentViewController as? ResultsTableViewController)!
    
  }

  func configureNavBar() {
//    let filterItem = createBarButton("filter_icon", actionName: "filter")
    let rightItem = createBarButton("list_icon", actionName: "modifyList", width: 30, height: 24)
    self.navigationItem.rightBarButtonItem = rightItem
    let leftItem = createBarButton("home_icon", actionName: "returnToMainSelection", width: 30, height: 24)
    self.navigationItem.leftBarButtonItem = leftItem
//    let backItem = UIBarButtonItem(image: UIImage(named: "home_icon"), style: .Plain, target: self, action: nil)
//    navigationItem.leftBarButtonItem = backItem
  }
  
  func createBarButton(imageName: String, actionName: String, width: Int, height: Int) -> UIBarButtonItem {
    let img = UIImage(named: imageName)
    let button: UIButton = UIButton(frame: CGRect(x: 0,y: 0, width: width, height: height))
    button.setBackgroundImage(img, forState: .Normal)
    button.addTarget(self, action: Selector(actionName), forControlEvents: UIControlEvents.TouchUpInside)
    return UIBarButtonItem(customView: button)
  }
  
  func returnToMainSelection() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func reloadMapView() {
    rmvc.reloadView()
  }
  
  func modifyList() {
    rtvc.searchController.active = false
    performSegueWithIdentifier("filterAndSort", sender: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  @IBAction func indexChanged(sender: UISegmentedControl) {
    switch toggleView.selectedSegmentIndex {
    case 0:
      rtvc.searchController.active = false
      mapViewContainer.hidden = true
      listViewContainer.hidden = false
      viewType = "List"
    case 1:
      rtvc.searchController.active = false
      mapViewContainer.hidden = false
      listViewContainer.hidden = true
      viewType = "Map"
      
    default:
      break;
    }
  }
    
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if let dtvc = segue.destinationViewController.contentViewController as? DetailsTableViewController {
      if segue.identifier == "See Detail (Table)" {
        dtvc.venueID = selectedVenueID!
        dtvc.prevViewTitle = "< List"
        configureNavBar()
      } else if segue.identifier == "See Detail (Map)" {
        dtvc.venueID = venueAnnotation!.venueID
        dtvc.prevViewTitle = "< Map"
        configureNavBar()
      }
    }
  }
  

}






