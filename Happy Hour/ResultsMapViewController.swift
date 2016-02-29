//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit
import MapKit

class ResultsMapViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate, CoreLocationManagerDelegate
{
    
  let client = Client.Instance.singleton
  
//  private var clm = CoreLocationManager.SharedInstance
  
  private var annotationPoints = [VenueMKAnnotation]()
  private var zoomField: MKMapRect? = nil
  private var infoViewAlpha: CGFloat = 0.0
  private var currentUserLocation: CLLocation? = nil
    
  @IBOutlet weak var mapInfoView: UIView!
  @IBOutlet weak var mapToolbar: UIToolbar!
  @IBOutlet weak var mapView: MKMapView!

//  override func viewWillAppear(animated: Bool) {
//    self.currentUserLocation = mapView.userLocation.location
//    reloadView()
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let locateUserButton = createBarButton("compass_icon", actionName: "locateUserOnMap", width: 24, height: 24)
    let flexSpace1 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    // TODO: Consider refresh icon
//    let refreshLocationButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: Selector("refreshDataForNewLocation"))
    let refreshLocationButton = UIBarButtonItem(title: "[ Refresh Data ]", style: .Plain, target: self, action: Selector("refreshDataForNewLocation"))
    refreshLocationButton.tintColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0)
    let flexSpace2 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let mapInfoButton = createBarButton("info_icon", actionName: "getMapOptions", width: 24, height: 24)
    toolbarItems = [locateUserButton, flexSpace1, refreshLocationButton, flexSpace2, mapInfoButton]
    mapToolbar.setItems(toolbarItems, animated: true)
    
    mapTypeSegmentedControl.selectedSegmentIndex = Defaults.getMapType()
    self.setMapTypeFromDefaults()
    mapView.delegate = self
    self.mapView.showsUserLocation = true // add to show user location
    
//    clm.completionHandler = { (loc) -> () in
//      self.updateCurrentLocation(loc)
//    }
    
    mapInfoView.alpha = 0.0
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func reloadView() {
    clearAnnotations()
    retrieveVenueAnnotations()
  }
  
//  func filterAnnotations() {
//    let annotationsToRemove = mapView.annotations.filter { !self.client.isVenueFilteredOut((($0).annotation as! VenueMKAnnotation).venueID) }
//    mapView.removeAnnotations( annotationsToRemove )
//  }
  
  private func createBarButton(imageName: String, actionName: String, width: Int, height: Int) -> UIBarButtonItem
  {
    let img = UIImage(named: imageName)
    let button: UIButton = UIButton(frame: CGRect(x: 0,y: 0, width: width, height: height))
    button.setBackgroundImage(img, forState: .Normal)
    button.addTarget(self, action: Selector(actionName), forControlEvents: UIControlEvents.TouchUpInside)
    return UIBarButtonItem(customView: button)
  }
  
  @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
  @IBAction func changeMapType(sender: UISegmentedControl) {
    let newMapType = sender.selectedSegmentIndex
    if newMapType == 0 {
      mapView.mapType = .Standard
    } else if newMapType == 1 {
      mapView.mapType = .Hybrid
    } else if newMapType == 2 {
      mapView.mapType = .Satellite
    }
    Defaults.setMapType(sender.selectedSegmentIndex)
  }
  
  private func setMapTypeFromDefaults()
  {
    switch(Defaults.getMapType())
    {
    case 0:
      mapView.mapType = .Standard
    case 1:
      mapView.mapType = .Hybrid
    case 2:
      mapView.mapType = .Satellite
    default:
      mapView.mapType = .Standard
    }
  }
  
  func updateCurrentLocation(location: CLLocation?) {
    self.currentUserLocation = location!
  }
  
  func locateUserOnMap() {
    //TODO: Go to user location
    if let currLoc = self.currentUserLocation?.coordinate {
      mapView.centerCoordinate = currLoc
    }
  }
    
  func refreshDataForNewLocation() {
    //TODO: Show results for venues in current map view.
  }
  
  func getMapOptions() {
    if (infoViewAlpha == 1.0) {
      infoViewAlpha = 0.0
    } else {
      infoViewAlpha = 1.0
    }
    mapInfoView.alpha = infoViewAlpha
//    mapView.alpha = 0.0
  }

  
  private func retrieveVenueAnnotations()
  {
    for i in 0..<client.getNumVenues() {
      let venue = client.getVenue(i)
      // Filters out venues for Deal Cell filters (only when Deals type cells are toggled)
      if (!client.cellType() || Defaults.getDealCategoryStatus(venue.dealCategories))
      {
        let coords = CLLocationCoordinate2D(latitude: venue.latitude, longitude: venue.longitude)
        let venueAnnotation = VenueMKAnnotation(coords: coords)
        venueAnnotation.businessID = "\(client.getVenueID(i))"
        venueAnnotation.name = venue.bName
        venueAnnotation.address = venue.address
        venueAnnotation.logo = venue.logo
        venueAnnotation.businessType = "\(venue.bType)"
        setAnnotation(venueAnnotation)
      }
    }
    annotateMap()
  }
  
  private func setAnnotation(annotation: VenueMKAnnotation)
  {
    annotationPoints.append(annotation)
    let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
    let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.3, 0.3)
    if let _ = self.zoomField {
      self.zoomField = MKMapRectUnion(self.zoomField!, pointRect)
    } else {
      self.zoomField = pointRect
    }
  }
  
  private func annotateMap() {
    self.mapView.addAnnotations(annotationPoints)
    self.mapView.showAnnotations(annotationPoints, animated: true)
    if let _ = self.zoomField {
      self.mapView.setVisibleMapRect(self.zoomField!, edgePadding: UIEdgeInsetsMake(40, 40, 40, 40), animated: true)
    }
  }

  
  private func clearAnnotations() {
    if mapView?.annotations != nil { mapView.removeAnnotations(mapView.annotations) }
    annotationPoints.removeAll()
    zoomField = nil
  }
  
  // MARK: - MKMapViewDelegate
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

    if annotation is MKUserLocation { return nil }
    var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Storyboard.AnnotationViewReuseIdentifier)
    if view == nil {
      view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Storyboard.AnnotationViewReuseIdentifier)
      view!.canShowCallout = true
    } else {
      view!.annotation = annotation
    }
    
    view!.leftCalloutAccessoryView = nil
    view!.rightCalloutAccessoryView = nil
    
    if let _ = annotation as? VenueMKAnnotation {
      view!.leftCalloutAccessoryView = UIButton(frame: Storyboard.LeftCalloutFrame)
      view!.rightCalloutAccessoryView = UIButton(type: UIButtonType.InfoDark)
    }
    return view
  }
  
  
  func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
    if let venueAnnotation = view.annotation as? VenueMKAnnotation {
      let businessImg = client.getLogoForVenue(venueAnnotation.venueID, bType: venueAnnotation.bType, encodedLogoOptional: venueAnnotation.encodedPNG)
      if view.leftCalloutAccessoryView == nil {
        // a thumbnail must have been added since the annotation view was created
        view.leftCalloutAccessoryView = UIButton(frame: Storyboard.LeftCalloutFrame)
      }
      if view.rightCalloutAccessoryView == nil {
        view.rightCalloutAccessoryView = UIButton(type: UIButtonType.InfoDark)
      }
      if let imageButton = view.leftCalloutAccessoryView as? UIButton {
        imageButton.setImage(businessImg, forState: .Normal)
      }
    }
  }
  
  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if let venueAnnotation = view.annotation as? VenueMKAnnotation {
      (parentViewController as? ResultsViewController)?.venueAnnotation = venueAnnotation
      (parentViewController as? ResultsViewController)?.performSegueWithIdentifier(Storyboard.VenueDetailSegue, sender: view)
    }
  }

  // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // No segues so far.
  }

  // MARK: - Constants
  
  private struct Storyboard {
    static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
    static let RightCalloutFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
    static let AnnotationViewReuseIdentifier = "Map Annotation"
    static let VenueDetailSegue = "See Detail (Map)"
  }
  
  // Updates user location:
  func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    self.currentUserLocation = userLocation.location
//    mapView.centerCoordinate = userLocation.location!.coordinate
  }

    
    
}

// TRY TO SET PIN COLOR:

//  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//
//    if annotation is MKUserLocation {
//      return nil
//    }
//
//    let reuseId = "pin"
//    var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
//    if pinView == nil {
//      pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//      pinView!.canShowCallout = true
//      pinView!.animatesDrop = true
//      pinView!.pinColor = .Purple
//    } else {
//      pinView!.annotation = annotation
//    }
//    return pinView
//  }

// TRY TO FIND LOCATION FROM ADDRESS NAME:

//        var fullAddress = "\(firstDeal.address), \(loc.name), \(loc.state)"
//        var geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(fullAddress, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
//          if let placemark = placemarks?[0] as? CLPlacemark {
//            let pm = MKPlacemark(placemark: placemark)
//            var dealIDs = venues[venueID]
//            let venueAnnotation = VenueMKAnnotation(coords: pm.coordinate, deals: dealIDs!)
//            venueAnnotation.businessID = "\(firstDeal.businessID)"
//            venueAnnotation.name = firstDeal.bName
//            venueAnnotation.address = firstDeal.address
//            venueAnnotation.logo = firstDeal.logo
//            venueAnnotation.businessType = "\(firstDeal.bType)"
//            //println("address: \(firstDeal.address), lat: \(pm.coordinate.latitude), lon: \(pm.coordinate.longitude)")
//            self.setAnnotation(venueAnnotation)
//          }
//          numVenuesLeft -= 1
//          if numVenuesLeft == 0 {
//            self.annotateMap()
//          }
//        })
//      }
//    }
//  }
