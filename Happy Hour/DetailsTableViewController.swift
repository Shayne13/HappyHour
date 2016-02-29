//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit
import MapKit

class DetailsTableViewController: UITableViewController, MKMapViewDelegate {
    
  let client = Client.Instance.singleton
  
  var prevViewTitle: String? = nil // 'List' or 'Map'
  private var venue: Venue? = nil
  var venueID: Int = -1 {
    didSet {
      venue = client.getVenueByIndex(venueID)!
    }
  }
  
  private var mapCell: DetailsMapCell? = nil
  
  private struct Storyboard
  {
    struct CellIdentifier
    {
      static let MapCell = "DetailsMapCell"
      static let VenueNameCell = "DetailsVenueNameCell"
      static let UtilityCell = "DetailsUtilityCell"
      static let StyleCell = "DetailsVenueStyleCell"
      static let DealCell = "DetailsDealCell"
    }
    struct CellDimensions
    {
      static let SectionZeroCellHeights = [200.0, 80.0, 60.0]
      static let DealSectionCellHeight: CGFloat = 45.0
      static let StyleHeaderHeight: CGFloat = 36.0
      static let HeaderHeight: CGFloat = 36.0
    }
    struct CellText
    {
      static let Inset: CGFloat = 6.0
      static let AllDay = "All Day"
      static let Style = "STYLE"
    }
    struct Segues
    {
      static let SeeFullMap = "See Full Map"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.estimatedRowHeight = tableView.rowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    
    let backItem = UIBarButtonItem(title: self.prevViewTitle, style: .Plain, target: self, action: Selector("returnToResults"))
    self.navigationItem.leftBarButtonItem = backItem
    
    //    tableView.separatorStyle = .None // TODO: Customize
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2 + venue!.numDealTimeSections()
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    switch(section) {
    case 0:
      return 3
    case 1:
      return 1
    default:
      return venue!.numDealsForTimeRange(section - 2)
    }
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if (section == 1) { // Header for Venue Style Cell:
      
      let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: Storyboard.CellDimensions.StyleHeaderHeight))
      let label = UILabel(frame: CGRect(x: Storyboard.CellText.Inset, y: 0, width: (tableView.frame.size.width/2), height: Storyboard.CellDimensions.StyleHeaderHeight))
      view.backgroundColor = UIColor.grayColor()
      label.text = "STYLE"
      label.textColor = UIColor.whiteColor()
      view.addSubview(label)
      
      let facilities = createCombinedVenueFacilityImage(UIColor.cyanColor(), alphaValue: 0.8)
      if let facilityImageViewer = facilities {
        view.addSubview(facilityImageViewer)
      }
      return view
      
    } else if (section >= 2) { // Headers for Deal Cells (Time Availability):
      
      let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: Storyboard.CellDimensions.HeaderHeight))
      let label = UILabel(frame: CGRect(x: Storyboard.CellText.Inset, y: 0, width: tableView.frame.size.width, height: Storyboard.CellDimensions.HeaderHeight))
      view.backgroundColor = UIColor.grayColor()
      label.text = convertStringToTimeLabel(venue!.getTimeKeyForDetailsSectionHeader(section - 2))
      label.textColor = UIColor.whiteColor()
      view.addSubview(label)
      return view
      
    }
    return nil
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    
    if (indexPath.section == 0) {
      if (indexPath.row == 0) {
        mapCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier.MapCell) as? DetailsMapCell
        mapCell?.createMap(venueID)
        return mapCell!
      } else if (indexPath.row == 1) {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier.VenueNameCell) as! DetailsVenueNameCell
        cell.title.text = venue?.bName
        cell.subtitle.text = venue?.address
        return cell
      } else {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier.UtilityCell) as! DetailsUtilityCell
        return cell
      }
    } else if (indexPath.section == 1) {
      let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier.StyleCell) as! DetailsVenueStyleCell
      cell.title.text = client.fullVenueDescription(venueID)
      return cell
    } else { // Deal sections:
      let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier.DealCell) as! DetailsDealCell
      let dealID = venue!.getDealIDForDetailsIndexPath(indexPath.section - 2, row: indexPath.row)
      cell.title.text = client.fullDealLabel(dealID)
      let imgName = (client.getDealByIndex(dealID)!.fd == 0 ? "FoodIcon" : "DrinkIcon")
      cell.img.image = imageWithSize(imgName, size: CGSize(width: 30.0, height: Storyboard.CellDimensions.DealSectionCellHeight))
      
      return cell
    }
    
  }
  
  // Toggle the cell's checkmark, and set it's new status in the underlying status list.
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    if (indexPath == NSIndexPath(forRow: 0, inSection: 0)) {
      performSegueWithIdentifier(Storyboard.Segues.SeeFullMap, sender: nil)
    }
  }
  
  override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat
  {
    if (indexPath.section == 0)
    {
      return CGFloat(Storyboard.CellDimensions.SectionZeroCellHeights[indexPath.row])
    } else if (indexPath.section == 1) {
      return tableView.rowHeight
    } else {
      return Storyboard.CellDimensions.DealSectionCellHeight
    }
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch(section) {
    case 0:
      return 0
    case 1:
      return Storyboard.CellDimensions.StyleHeaderHeight
    case 2:
      return Storyboard.CellDimensions.HeaderHeight
    default:
      return Storyboard.CellDimensions.HeaderHeight
    }
  }
  
  // MARK: - Cells & Headers
  
  
  @IBAction func automatedCall(sender: UIButton)
  {
    let phoneURL = NSURL(string: "tel://\(venue!.phone)")
    UIApplication.sharedApplication().openURL(phoneURL!);
  }
  
  
  @IBAction func automatedDirections(sender: UIButton)
  {
    let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(venue!.latitude, venue!.longitude), addressDictionary: nil))
    destination.name = venue!.bName
    let currentLocation = MKMapItem.mapItemForCurrentLocation()
    let launchOptions = [ MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving ]
    // TODO: Determine MKLaunchOptionsDirectionsModeDriving / MKLaunchOptionsDirectionsModeWalking based on proximity
    MKMapItem.openMapsWithItems([currentLocation, destination], launchOptions: launchOptions)
  }
  
  
  @IBAction func automatedWebLink(sender: UIButton)
  {
    if let url = NSURL(string: venue!.website) {
      UIApplication.sharedApplication().openURL(url)
    }
  }

  
  // Determines the number of facilities (patio, pt, tv) available at the venue and packs them into
  // a single image (then tinted and made a little transparent). An image view is created to
  // appropriately spaced and formatt the combined image into the header cell.
  private func createCombinedVenueFacilityImage(tintColor: UIColor, alphaValue: CGFloat) -> UIImageView? {
    
    let verticalBuffer: CGFloat = 3.0
    let imageHeight: CGFloat = Storyboard.CellDimensions.StyleHeaderHeight - (verticalBuffer * 2.0)
    let imageWidth: CGFloat = 40.0
    let horizontalBuffer: CGFloat = 12.0
    let imageSize = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
    let numImages = CGFloat(venue!.tv + venue!.pt + venue!.patio)
    
    if (numImages == 0) { return nil } // If there are no facilities to show as images, then return.
    
    let totalRequiredWidth = (numImages * imageWidth) + ((numImages - 1) * horizontalBuffer) + Storyboard.CellText.Inset
    
    let patio = UIImage(named: "patio")!.resizeAndFrame(imageSize, frameColor: UIColor.blackColor(), borderWidth: 1.0, cornerRadius: 1.0)
    let pt = UIImage(named: "pool_table")!.resizeAndFrame(imageSize, frameColor: UIColor.blackColor(), borderWidth: 1.0, cornerRadius: 1.0)
    let tv = UIImage(named: "television")!.resizeAndFrame(imageSize, frameColor: UIColor.blackColor(), borderWidth: 1.0, cornerRadius: 1.0)
    
    // Set up the new image context.
    UIGraphicsBeginImageContext(CGSize(width: totalRequiredWidth, height: Storyboard.CellDimensions.StyleHeaderHeight))
    var horizontalOffset: CGFloat = 0.0
    
    if (venue!.patio == 1) { // Add patio image
      patio.drawInRect(CGRect(x: horizontalOffset, y: verticalBuffer, width: imageSize.width, height: imageSize.height))
      horizontalOffset = horizontalOffset + imageWidth + horizontalBuffer
    }
    
    if (venue!.pt == 1) { // Add pool table image
      pt.drawInRect(CGRect(x: horizontalOffset, y: verticalBuffer, width: imageSize.width, height: imageSize.height))
      horizontalOffset = horizontalOffset + imageWidth + horizontalBuffer
    }
    
    if (venue!.tv == 1) { // Add tv image
      tv.drawInRect(CGRect(x: horizontalOffset, y: verticalBuffer, width: imageSize.width, height: imageSize.height))
    }
    
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    // Finished creating combination image.
    
    // Add tint and alpha modifications to image, frame it in header cell then return the image view
    let tintedFacilitiesImage = newImage.alpha(alphaValue).tint(tintColor).alpha(alphaValue) // The 1st alpha allows tint to work better
    let facilities = UIImageView(image: tintedFacilitiesImage)
    facilities.frame = CGRect(x: (tableView.frame.size.width - totalRequiredWidth), y: 0, width: totalRequiredWidth, height: Storyboard.CellDimensions.StyleHeaderHeight)
    return facilities
  }
  
  private func convertStringToTimeLabel(timeKey: String) -> String {
    
    if (timeKey == "00:00:00-23:59:00") { return Storyboard.CellText.AllDay }
    
    let times = timeKey.characters.split{$0 == "-"}.map(String.init) // "HH:mm:ss-HH:mm:ss"
    let fromTime = times[0].characters.split{$0 == ":"}.map(String.init) // ["HH", "mm", "ss"]
    let toTime = times[1].characters.split{$0 == ":"}.map(String.init) // ["HH", "mm", "ss"]
    
    let militaryFromHour = Int(fromTime[1]) == 59 ? Int(fromTime[0])! + 1 : Int(fromTime[0])!
    let militaryToHour = Int(toTime[1]) == 59 ? Int(toTime[0])! + 1 : Int(toTime[0])!
    
    let from = (militaryFromHour > 12) ? String(militaryFromHour - 12) + " PM" : String(militaryFromHour) + " AM"
    let to = (militaryToHour > 12) ? String(militaryToHour - 12) + " PM" : String(militaryToHour) + " AM"

    return from + " - " + to
  }
  
  
  // MARK: - Navigation:
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if segue.identifier == Storyboard.Segues.SeeFullMap {
      if let dmvc = segue.destinationViewController.contentViewController as? DetailsMapViewController {
        dmvc.venueID = venueID
//        self.navigationItem.backBarButtonItem = backItem
      }
    }
  }
  
  func returnToResults() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }

  

}



