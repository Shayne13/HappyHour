//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

//import Foundation
import UIKit

class Client
{
    
  // MARK: - Shared Instance of Client
    
  struct Instance { // Shared instance of Client.
    static let singleton = Client()
  }
  
  // MARK: - Selections, Filters and Sorting

  func cellType() -> Bool {
    return Defaults.getCellType()
  }
//  var cellType: Bool = Defaults.getCellType() {
//    didSet {
//      println("set cell type")
//    }
//  }
  
  
  var selectedLocation: Location? = nil
  var Drinks: Bool = false
  var Food: Bool = false
  
  var recentlyResortedResults: Bool = false
  
  // Filters:
  private var dealCategoryFilters = [Int]()
  private var businessClassFilters = [Int]()
  
  // MARK: - Stored Fields
  
  // Deals:
  private var HappyHourDeals = [Int: Deal]() // All deals from fetch request
  private var HappyHourDealKeys = [Int]() // All dealIDs - sorted
  private var HappyHourDealDisplayKeys = [Int]() // dealIDs - sorted and filtered (subset of HappyHourDealKeys)
  
  // Venues:
  private var HappyHourVenues = [Int: Venue]() // All venues from fetch request
  private var HappyHourVenueKeys = [Int]() // All venueIDs - sorted
  private var HappyHourVenueDisplayKeys = [Int]() // venueIDs - sorted and filtered (subset of HappyHourVenueKeys)
  private var HappyHourVenue: Venue? = nil // Venue from venue fetch request
  private var HappyHourVenueLogoCache = [Int: UIImage]() // venueID -> Logo (png)
  
  // Locations:
  private var HappyHourLocations = [Int: Location]() // All locations from fetch, by location ID
  private var listOfStates = [String]()
  private var orderedLocations = [Int: [Int]]() // stateID -> [ cityIDs and districtIDs ]
  
  // Basic Fields:
  var DealTypes = [Int: String]()
  var DealCategories = [Int: String]()
  var BusinessClasses = [Int: String]()
  var DealOps = [Int: (String, String)]() // [0]: Name, [1]: Symbol
  var BusinessTypes = [Int: (String, UIImage)]() // [0]: Name, [1]: Logo (png)
  
  // Basic Fields DidSet Bools:
  var dealTypesSet = false
  var dealCategoriesSet = false
  var businessClassesSet = false
  var dealOpsSet = false
  var businessTypesSet = false
  var locationsSet = false
    
  // Fields to fetch at app launch (by type):
  private let earlyFetchFields = [Server.RequestType.bType, Server.RequestType.bClass,
      Server.RequestType.dType, Server.RequestType.dCat,
      Server.RequestType.dOp, Server.RequestType.city]
  // Fields with the result of form [Int: String]():
  private let basicField = [Server.RequestType.dCat, Server.RequestType.dType,
      Server.RequestType.bClass]
  // Fields with the result of form [Int: (String, String)]():
  private let basicTupleField = [Server.RequestType.dOp, Server.RequestType.bType]
  
  // MARK: - Server Requests
  
  private struct Server {
    static let BaseURL = "http://www.moosto.ca/api.php"
    static let RequestKey = "6d6f6f7365"
    struct RequestType {
      static let deal = "1" // Deprecated.
      static let business = "2"
      static let city = "3"
      static let dType = "4"
      static let dCat = "5"
      static let bType = "6"
      static let bClass = "7"
      static let dOp = "8"
      static let search = "9"
      static let pubClass = "10"
    }
  }
    
  // MARK: - HTTP Request: Fetch Basic Fields
  
  // Asynchronously retrieve all basic fields on app launch:
  func fetchBasicFields() {
    for type in earlyFetchFields {
      let session = NSURLSession.sharedSession()
      let task = session.dataTaskWithURL(buildQuery(type)) {
        (data, response, error) -> Void in
        if error == nil {
          let parser = JSONParser()
          if type == Server.RequestType.city {
            (self.HappyHourLocations, self.orderedLocations, self.listOfStates) = parser.parseLocations(data!)
            self.locationsSet = true
          } else if self.basicField.contains(type) {
            let result = parser.parseBasicField(data!)
            self.setBasicField(result, type: type)
          } else {
            let detailName = (type == Server.RequestType.dOp ? "symbol" : "logo")
            let result = parser.parseBasicTupleField(data!, detailName: detailName)
            self.setBasicField(result, type: type)
          }
        } else {
          print("HTTP Response: \(response)")
          print("HTTP Response Error: \(error)")
          print("HTTP Response Data: \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
        }
      }
      task.resume()
    }
      
  }
  
  // MARK: - HTTP Request: Fetch Deals
  
  func fetchDeals(success:() -> ()) {
    
    let session = NSURLSession.sharedSession()
    let request = buildQuery(Server.RequestType.search, params: getSearchParams())
    
    let task = session.dataTaskWithURL(request) {
      (data, response, error) -> Void in
      if error == nil {
        let parser = JSONParser()
        (self.HappyHourDeals, self.HappyHourVenues) = parser.parseDeals(data!)
        self.HappyHourDealKeys = Array(self.HappyHourDeals.keys)
        self.HappyHourVenueKeys = Array(self.HappyHourVenues.keys)
        self.sortResults(true)
        success()
      } else {
        print("HTTP Response: \(response)")
        print("HTTP Response Error: \(error)")
        print("HTTP Response Data: \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
      }
    }
    task.resume()
  }
  
  // MARK: - HTTP Request: Fetch Venue
  
  func fetchVenue(businessID: Int) {
    
    let session = NSURLSession.sharedSession()
    let request = buildQuery(Server.RequestType.business, params: ["businessID": "\(businessID)"])
    
    let task = session.dataTaskWithURL(request) {
      (data, response, error) -> Void in
      if error == nil {
        let parser = JSONParser()
        self.HappyHourVenue = parser.parseVenue(data!)
      } else {
        print("HTTP Response: \(response)")
        print("HTTP Response Error: \(error)")
        print("HTTP Response Data: \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
      }
    }
    task.resume()
  }

  // MARK: - Fetch Helper Methods
  
  private func setBasicField(result: [Int: String], type: String) {
    switch type {
    case Server.RequestType.dCat:
      self.DealCategories = result
      self.dealCategoriesSet = true
    case Server.RequestType.dType:
      self.DealTypes = result
      self.dealTypesSet = true
    case Server.RequestType.bClass:
      self.BusinessClasses = result
      self.businessClassesSet = true
    default:
      print("Error setting basic field: \(type)")
    }
  }
    
  private func setBasicField(result: [Int: (String, String)], type: String) {
    switch type {
    case Server.RequestType.dOp:
      self.DealOps = result
      self.dealOpsSet = true
    case Server.RequestType.bType:
      for (index, (name, encodedLogo)) in result {
        let img = fetchEncodedImage(encodedLogo)
        self.BusinessTypes[index] = (name, img!)
      }
      self.businessTypesSet = true
    default:
      print("Error setting basic field: \(type)")
    }
  }
    
  // Check that we have completed fetching all basic fields:
  func basicFieldsSet() -> Bool {
    return dealOpsSet && businessTypesSet && dealCategoriesSet && dealTypesSet && businessClassesSet && locationsSet
  }
  
  // Build a query given the type, and a map of additional parameters.
  private func buildQuery(type: String, params: [String: String]) -> NSURL {
    let baseQuery = "\(Server.BaseURL)?key=\(Server.RequestKey)&type=\(type)&"
    let fullQuery = baseQuery + params.getHTTPRequestParamsAsString()
    return NSURL(string: fullQuery)!
  }
    
  // Build a query given just the type (there are no additional parameters.
  private func buildQuery(type: String) -> NSURL {
    let fullQuery = "\(Server.BaseURL)?key=\(Server.RequestKey)&type=\(type)"
    return NSURL(string: fullQuery)!
  }
  
  // Builds Search Parameter dictionary:
  private func getSearchParams() -> [String: String] {
    var searchParams = [String: String]()
    //    searchParams["dType"] = "3" // Student deals
    if selectedLocation == nil {
      // Do nothing
    } else {
      searchParams["city"] = "\(selectedLocation!.cityID)"
      searchParams["recursive"] = "1"
    }
    if Drinks == false && Food == false { /* do nothing */ }
    else if Drinks == true && Food == true { /* do nothing */ }
    else if Drinks == true { searchParams["f-d"] = "1" }
    else if Food == true { searchParams["f-d"] = "0" }

    return searchParams
  }
  
  // Fetch of a base64 encoded PNG:
  private func fetchEncodedImage(encodedImage: String) -> UIImage? {
    let imgPNGData = NSData(base64EncodedString: encodedImage, options: NSDataBase64DecodingOptions(rawValue: 0))
    return UIImage(data: imgPNGData!)
  }
  
  // MARK: - Sort and Filter
  
  func sortResults(sortAll: Bool)
  {
    recentlyResortedResults = true
    
//    if (sortAll) {
//      sortDeals()
//      sortVenues()
//    } else if (self.cellType()) {
//      sortDeals()
//    } else {
//      sortVenues()
//    }
    
    filterResults(sortAll)
    recentlyResortedResults = false
  }
  
  private func sortDeals()
  {
    switch (Defaults.getSortType())
    {
    case 0: // Default
      HappyHourDealKeys.sortInPlace({ $0 > $1 })
    case 1: // Proximity
      HappyHourDealKeys.sortInPlace({ $0 > $1 })
    case 2:
      HappyHourDealKeys.sortInPlace({ self.getDealByIndex($0)!.bName > self.getDealByIndex($1)!.bName })
    default:
      print("sorting error")
    }
  }
  
  private func sortVenues()
  {
    switch (Defaults.getSortType())
    {
    case 0: // Default
      HappyHourVenueKeys.sortInPlace({ $0 > $1 })
    case 1: // Proximity
      HappyHourVenueKeys.sortInPlace({ $0 > $1 })
    case 2:
      HappyHourVenueKeys.sortInPlace({ self.getVenueByIndex($0)!.bName > self.getVenueByIndex($1)!.bName })
    default:
      print("sorting error")
    }
  }
  
  func filterResults(filterAll: Bool)
  {
    if (filterAll) {
      HappyHourDealDisplayKeys = HappyHourDealKeys.filter(dealFilterCriteria)
      HappyHourVenueDisplayKeys = HappyHourVenueKeys.filter(venueFilterCriteria)
    } else if (self.cellType()) { // Only Deal Type cells:
      HappyHourDealDisplayKeys = HappyHourDealKeys.filter(dealFilterCriteria)
    } else { // Only Venue Type cells:
      HappyHourVenueDisplayKeys = HappyHourVenueKeys.filter(venueFilterCriteria)
    }
  }
  
  private func dealFilterCriteria(dealID: Int) -> Bool // True means don't filter out; false means filter out
  {
    let deal = self.getDealByIndex(dealID)!
    
    // filter by business type (restaurant / cafe / bar)
    // filter availability (currently open/available)
    // TODO: Make the categories in defaults nsset instead. If set is nil or you're in set then you're not filtered.
    if (!Defaults.getDealCategoryStatus(deal.dCat)) { return false }
    
    return true
  }
  
  private func venueFilterCriteria(venueID: Int) -> Bool
  {
    let venue = self.getVenueByIndex(venueID)!
    
    if (!Defaults.getBusinessClassStatus(venue.allBusinessClasses())) { return false }
    
    return true
  }

  
  // MARK: - Results Table View Controller Data
  
  func getNumResultSections() -> Int {
    return 1
  }
  
  func getNumDeals() -> Int {
    return HappyHourDealDisplayKeys.count
  }
  
  func getNumVenues() -> Int {
    return HappyHourVenueDisplayKeys.count
  }
  
  func getNumResultRowsPerSection(section: Int) -> Int {
    return (cellType() ? getNumDeals() : getNumVenues())
  }
  
  func getDeal(row: Int) -> Deal {
    return HappyHourDeals[HappyHourDealDisplayKeys[row]]!
  }
  
  func getDealID(row: Int) -> Int {
    return HappyHourDealDisplayKeys[row]
  }

  func getDealByIndex(index: Int) -> Deal? {
    if let deal = HappyHourDeals[index] {
      return deal
    } else {
      return nil
    }
  }
  
  // ---------------------------
  
  func getVenue(row: Int) -> Venue {
    return HappyHourVenues[HappyHourVenueDisplayKeys[row]]!
  }
  
  func isVenueFilteredOut(index: Int) -> Bool {
    return HappyHourVenueDisplayKeys.contains(index)
  }

  func getVenueID(row: Int) -> Int {
    return HappyHourVenueDisplayKeys[row]
  }
  
  func getVenueByIndex(index: Int) -> Venue? {
    if let venue = HappyHourVenues[index] {
      return venue
    } else {
      return nil
    }
  }

  // ------ Helper functions / misc:
  
  func fullDealLabel(dealID: Int) -> String
  {
    let deal = HappyHourDeals[dealID]!
    let dn = deal.dNameS
    let op = DealOps[deal.dOp]!.1
    let value = deal.value.description
    let type = DealTypes[deal.dType]

    switch deal.dType {
    case 0:
      return joinStringsWith(" ", strings: op + value, dn) // TODO: %25.0 formatting
    case 1: // 50% Off
      return joinStringsWith(" ", strings: type!, dn)
    case 2: // 2 for 1
      return joinStringsWith(" ", strings: type!, op, value, dn)
    case 3: // Students
      return joinStringsWith(" ", strings: type!, op, value, dn)
    case 4: // Free
      return joinStringsWith(" ", strings: "FREE:", dn)
    case 5: // 3 for 2
      return joinStringsWith(" ", strings: type!, op, value, dn)
    case 6: // Food & Drink Combo
      return joinStringsWith(" ", strings: op + value, dn)
    default:
      return "Error"
    }
  }
  
  // Business class description for Venue cells: "Pizza, Pasta, Mediterranean"
  func fullVenueDescription(venueID: Int, joiner: String = "  •  ") -> String
  {
    let venue = HappyHourVenues[venueID]
    var businessClasses = [String]()
    
    if let bClass1 = BusinessClasses[venue!.bClass1] { businessClasses.append(bClass1) }
    if let bClass2 = BusinessClasses[venue!.bClass2] { businessClasses.append(bClass2) }
    if let bClass3 = BusinessClasses[venue!.bClass3] { businessClasses.append(bClass3) }

    return businessClasses.joinWithSeparator(joiner)
  }
  
  func joinStringsWith(joiner: String, strings: String...) -> String {
    var result = ""
    for s in strings {
      result += joiner + s
    }
    return result
  }

  // MARK: - Location Table View Controller Data
  
  func getNumLocationSections() -> Int {
    return listOfStates.count
  }
  
  func getStateSectionHeader(section: Int) -> String {
    return listOfStates[section]
  }
  
  func getNumLocationRowsPerSection(section: Int) -> Int {
    return orderedLocations[section]!.count
  }
  
  func getLocation(indexPath: NSIndexPath) -> Location {
    return HappyHourLocations[orderedLocations[indexPath.section]![indexPath.row]]!
  }
  
  func getLocationByIndex(index: Int) -> Location? {
    if let loc = HappyHourLocations[index] {
      return loc
    } else {
      return nil
    }
  }
  
  // MARK: - Miscellaneous
  
  // Gets logo from stored default logos, logo cache, or fetches it:
  func getLogoForVenue(businessID: Int, bType: Int, encodedLogoOptional: String?) -> UIImage?
  {
    if let encodedLogo = encodedLogoOptional {
      if HappyHourVenueLogoCache[businessID] != nil {
        return HappyHourVenueLogoCache[businessID]
      } else {
        let img = fetchEncodedImage(encodedLogo)
        HappyHourVenueLogoCache[businessID] = img!
        return img
      }
    } else {
      return BusinessTypes[bType]?.1
    }
  }
  

  
}

