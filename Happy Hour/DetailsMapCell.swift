//
//  DetailsMapCell.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 9/8/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit
import MapKit

class DetailsMapCell: UITableViewCell, MKMapViewDelegate {

  let client = Client.Instance.singleton
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.map.delegate = self
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  private struct Constants {
    static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
    static let AnnotationViewReuseIdentifier = "Map Annotation"
  }

  
  @IBOutlet weak var map: MKMapView!
  
  func createMap(venueID: Int)
  {
    let venue = client.getVenueByIndex(venueID)!
    let coords = CLLocationCoordinate2D(latitude: venue.latitude, longitude: venue.longitude)
    let venueAnnotation = VenueMKAnnotation(coords: coords)
    venueAnnotation.logo = venue.logo
    venueAnnotation.businessID = "\(venueID)"
    venueAnnotation.name = venue.bName
    venueAnnotation.address = venue.address
    venueAnnotation.logo = venue.logo
    venueAnnotation.businessType = "\(venue.bType)"
    
    var region = self.map.region
    region.center = coords
    region.span = MKCoordinateSpanMake(0.01, 0.01)
    self.map.setRegion(region, animated: true)
    self.map.addAnnotation(venueAnnotation)
//    self.map.selectAnnotation(venueAnnotation, animated: true)
  }
  
//  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//    var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)
//
//    if view == nil {
//      view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
//      view!.canShowCallout = true
//    } else {
//      view!.annotation = annotation
//    }
//    
//    view!.leftCalloutAccessoryView = nil
//    
//    if let _ = annotation as? VenueMKAnnotation {
//      view!.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
//    }
//    return view
//  }
//  
//  func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//    if let venueAnnotation = view.annotation as? VenueMKAnnotation {
//      let businessImg = client.getLogoForVenue(venueAnnotation.venueID, bType: venueAnnotation.bType, encodedLogoOptional: venueAnnotation.encodedPNG)
//      
//      if view.leftCalloutAccessoryView == nil {
//        // a thumbnail must have been added since the annotation view was created
//        view.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
//      }
//
//      
//      if let imageButton = view.leftCalloutAccessoryView as? UIButton {
//        imageButton.setImage(businessImg, forState: .Normal)
//      }
//
//    }
//  }

  
}
