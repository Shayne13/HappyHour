//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import Foundation
import CoreLocation

// Resources: TODO Rewrite this:
// 1. https://github.com/varshylmobile/LocationManager/blob/master/LocationManager.swift
// 2. http://www.johnmullins.co/blog/2014/08/14/location-tracker-with-maps/
// Attempting to create CLM singleton as in (1), where each view controller that needs it has it
// as a delegate and passes in a completion handler 'LocationUpdateCompletionHandler' which
// will be called in 'didUpdateLocations'. This acts as a notification/trigger to update the 
// mapview for the independent controller in some way.

typealias LocationUpdateCompletionHandler = ((location: CLLocation) -> ())?

class CoreLocationManager: NSObject, CLLocationManagerDelegate
{
  
  static let SharedInstance = CoreLocationManager()
  
//  struct Shared { // Shared instance of Client.
//    static let Instance = CoreLocationManager()
//  }
  
  private var locationManager: CLLocationManager = CLLocationManager()
  var completionHandler: LocationUpdateCompletionHandler
  
  var delegate: CoreLocationManagerDelegate? = nil
  
  var currentStatus: CLAuthorizationStatus? = nil
  var currentAddress: String? = nil
  var currentLocation: CLLocation? = nil {
    didSet {
      self.currentAddress = reverseGeocodeLocation(currentLocation)
    }
  }
  
  override init() {
    super.init()
    self.locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
  }
  
  func startCoreLocationManager() {
    locationManager = CLLocationManager()
    self.locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
  }
  
  internal func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
  {
    switch status {
      case .AuthorizedAlways, .AuthorizedWhenInUse:
        print(".Authorized")
        self.locationManager.startUpdatingLocation()
      case .Denied, .Restricted:
        print(".Denied")
      case .NotDetermined:
        print(".NotDetermined")
    }
    self.currentStatus = status
  }
  
  internal func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.currentLocation = locations.last
    
    if (completionHandler != nil) { completionHandler!(location: self.currentLocation!) }
    
//    print("didUpdateLocations:  \(self.currentLocation!.coordinate.latitude), \(self.currentLocation!.coordinate.longitude)")
  }
  
  
  internal func reverseGeocodeLocation(location: CLLocation?) -> String?
  {
    // TODO: Implement this.
    return "Current Location Test"
  }
  
  
  
  
    
}

@objc protocol CoreLocationManagerDelegate : NSObjectProtocol
{
//  func locationFound(latitude:Double, longitude:Double)
//  optional func locationFoundGetAsString(latitude:NSString, longitude:NSString)
//  optional func locationManagerStatus(status:NSString)
//  optional func locationManagerReceivedError(error:NSString)
//  optional func locationManagerVerboseMessage(message:NSString)
}