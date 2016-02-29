//
//  DetailsMapViewController.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 9/11/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit
import MapKit


class DetailsMapViewController: UIViewController, MKMapViewDelegate
{

  let client = Client.Instance.singleton
  
  var venue: Venue? = nil
  var venueID: Int = -1 {
    didSet {
      venue = client.getVenueByIndex(venueID)!
    }
  }

  @IBOutlet weak var map: MKMapView!
  @IBOutlet weak var bottomBar: UIToolbar!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .Plain, target: self, action: Selector("returnToDetail"))
    self.navigationItem.title = "Locator"
    
    let locateUserButton = createBarButton("compass_icon", actionName: "locateUserOnMap", width: 24, height: 24)
    let flexSpace1 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    
    let mapTypeItems = ["Standard", "Hybrid", "Satellite"]
    let mapTypeController = UISegmentedControl(items: mapTypeItems)
    mapTypeController.selectedSegmentIndex = 0
    mapTypeController.addTarget(self, action: "changeMapType:", forControlEvents: .ValueChanged)
    self.view.addSubview(mapTypeController)
    
    let mapTypeControllerButton = UIBarButtonItem(customView: mapTypeController)
    
    let flexSpace2 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let mapInfoButton = createBarButton("info_icon", actionName: "getMapOptions", width: 24, height: 24)
    toolbarItems = [locateUserButton, flexSpace1, mapTypeControllerButton, flexSpace2, mapInfoButton]
    
    bottomBar.setItems(toolbarItems, animated: true)
    
    map.mapType = .Standard
    
    self.loadMap()
  }
  
  func returnToDetail() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func locateUserOnMap()
  {
    print("locate")
  }
  
  func changeMapType(sender: UISegmentedControl) {
    let newMapType = sender.selectedSegmentIndex
    if newMapType == 0 {
      map.mapType = .Standard
    } else if newMapType == 1 {
      map.mapType = .Hybrid
    } else if newMapType == 2 {
      map.mapType = .Satellite
    }
    // TODO: Defaults or no?
  }
  
  func getMapOptions()
  {
    print("get options")
  }
  
  func loadMap()
  {
    let coords = CLLocationCoordinate2D(latitude: venue!.latitude, longitude: venue!.longitude)
    let annotation = MKPointAnnotation()
    annotation.coordinate = coords
    annotation.title = venue!.bName
    annotation.subtitle = venue!.address
    
    var region = self.map.region
    region.center = coords
    region.span = MKCoordinateSpanMake(0.01, 0.01)
    self.map.setRegion(region, animated: true)
    self.map.addAnnotation(annotation)
    self.map.selectAnnotation(annotation, animated: true)
  }
  
  // TODO: This function is duplicated in RMVC.
  private func createBarButton(imageName: String, actionName: String, width: Int, height: Int) -> UIBarButtonItem
  {
    let img = UIImage(named: imageName)
    let button: UIButton = UIButton(frame: CGRect(x: 0,y: 0, width: width, height: height))
    button.setBackgroundImage(img, forState: .Normal)
    button.addTarget(self, action: Selector(actionName), forControlEvents: UIControlEvents.TouchUpInside)
    return UIBarButtonItem(customView: button)
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  */

}
