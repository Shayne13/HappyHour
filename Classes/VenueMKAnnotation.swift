//
//  VenueMKAnnotation.swift
//  Happy Hour
//
//  Created by Shayne on 2015-03-25.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import MapKit

class VenueMKAnnotation: NSObject
{
  var latitude: Double
  var longitude: Double
//  var deals: [Int] // dealIDs
  var attributes = [String: String]()
  
  init(coords: CLLocationCoordinate2D) {
    self.latitude = coords.latitude
    self.longitude = coords.longitude
//    self.deals = deals
    super.init()
  }
  
  var businessID: String? {
    set { attributes["businessID"] = newValue }
    get { return attributes["businessID"] }
  }
  
  var name: String? {
    set { attributes["name"] = newValue }
    get { return attributes["name"] }
  }
  
  var address: String? {
    set { attributes["address"] = newValue }
    get { return attributes["address"] }
  }
  
  var logo: String? {
    set { attributes["logo"] = newValue }
    get { return attributes["logo"] }
  }
  
  var businessType: String? {
    set { attributes["bType"] = newValue }
    get { return attributes["bType"] }
  }

}

extension VenueMKAnnotation: MKAnnotation
{
  // MARK: - MKAnnotation
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  var title: String? { return name }
  
  var subtitle: String? { return address }
  
  // MARK: - Venue Extensions
  
  var encodedPNG: String? { return logo }

//  var dealIDs: [Int] { return deals }
  
  var venueID: Int { return Int(businessID!)! }
  
  var bType: Int { return Int(businessType!)! }
  
}
