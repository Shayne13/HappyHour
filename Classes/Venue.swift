//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import Foundation

public class Venue
{
  
  // Member variables from Venue GET Request:
  
  var bName: String = ""
  var phone: String = ""
  var address: String = ""
  var city: Int = -1
  var website: String = ""
  var fb: String = ""
  var menu: String = ""
  var hMenu: String = ""
  var bType: Int = -1
  var bClass1: Int = -1 // 0 -> No associated class
  var bClass2: Int = -1 // 0 -> No associated class
  var bClass3: Int = -1 // 0 -> No associated class
  var price: Int = -1
  var patio: Int = -1
  var pt: Int = -1
  var tv: Int = -1
  
  // Extrapolated member variables, from Deal GET Request:
  
  var longitude: Double = -1.0
  var latitude: Double = -1.0
  var logo: String? = nil // can be <null>
  
  // DealIDs for deals from 00:00:00 to 23:59:00:
  var allDayDeals: [Int] = [Int]()
  // Times to DealIDs for deals at specific time ranges (not all day):
  var dealTimes: [String: [Int]] = [String: [Int]]()
  var numDrinkDeals: Int = 0
  var numFoodDeals: Int = 0
  var dealCategories: Set<Int> = Set()

  
  // MARK: Venue Init via Deal:
  
  init?(deal: Deal?) // Init'?' means failable init - can return nil.
  {
    if let bName = deal?.bName { self.bName = bName }
    if let phone = deal?.phone { self.phone = phone }
    if let address = deal?.address { self.address = address }
    if let city = deal?.city { self.city = city }
    if let website = deal?.website { self.website = website }
    
    if let bType = deal?.bType { self.bType = bType }
    if let bClass1 = deal?.bClass1 { self.bClass1 = bClass1 }
    if let bClass2 = deal?.bClass2 { self.bClass2 = bClass2 }
    if let bClass3 = deal?.bClass3 { self.bClass3 = bClass3 }
    
    if let patio = deal?.patio { self.patio = patio }
    if let pt = deal?.pt { self.pt = pt }
    if let tv = deal?.tv { self.tv = tv }
    
    if let longitude = deal?.longitude { self.longitude = longitude }
    if let latitude = deal?.latitude { self.latitude = latitude }
    if let logo = deal?.logo { self.logo = logo }
    
    return
  }
  
  // MARK: Venue Init via JSON Parsing:
  
  init?(data: NSDictionary?) {
    
    if let bName = data?.valueForKey(VenueKeys.bName) as? String {
      if let phone = data?.valueForKey(VenueKeys.phone) as? String {
        if let address = data?.valueForKey(VenueKeys.address) as? String {
          if let city = data?.valueForKey(VenueKeys.city) as? String {
            if let website = data?.valueForKey(VenueKeys.website) as? String {
              if let fb = data?.valueForKey(VenueKeys.fb) as? String {
                if let menu = data?.valueForKey(VenueKeys.menu) as? String {
                  if let hMenu = data?.valueForKey(VenueKeys.hMenu) as? String {
                    if let bType = data?.valueForKey(VenueKeys.bType) as? String {
                      if let bClass1 = data?.valueForKey(VenueKeys.bClass1) as? String {
                        if let bClass2 = data?.valueForKey(VenueKeys.bClass2) as? String {
                          if let bClass3 = data?.valueForKey(VenueKeys.bClass3) as? String {
                            if let price = data?.valueForKey(VenueKeys.price) as? String {
                              if let patio = data?.valueForKey(VenueKeys.patio) as? String {
                                if let pt = data?.valueForKey(VenueKeys.pt) as? String {
                                  if let tv = data?.valueForKey(VenueKeys.tv) as? String {
                                    
                                    self.bName = bName
                                    self.phone = phone
                                    self.address = address
                                    self.city = Int(city)!
                                    self.website = website
                                    self.fb = fb
                                    self.menu = menu
                                    self.hMenu = hMenu
                                    self.bType = Int(bType)!
                                    self.bClass1 = Int(bClass1)!
                                    self.bClass2 = Int(bClass2)!
                                    self.bClass3 = Int(bClass3)!
                                    self.price = Int(price)!
                                    self.patio = Int(patio)!
                                    self.pt = Int(pt)!
                                    self.tv = Int(tv)!
                                    return
                                      
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  // TODO: Check for failures.
    return nil
  }
  
  
  // MARK: - JSON Data Dictionary Keys:
  
  struct VenueKeys {
    static let bName = "bName"
    static let phone = "phone"
    static let address = "address"
    static let city = "city"
    static let website = "website"
    static let fb = "fb"
    static let menu = "menu"
    static let hMenu = "hMenu"
    static let bType = "bType"
    static let bClass1 = "bClass1"
    static let bClass2 = "bClass2"
    static let bClass3 = "bClass3"
    static let price = "price"
    static let patio = "patio"
    static let pt = "pt"
    static let tv = "tv"
  }
  
  func allBusinessClasses() -> Set<Int> {
    return Set([self.bClass1, self.bClass2, self.bClass3])
  }
  
  // Update existing Variable with a new deal
  func updateWithDeal(deal: Deal)
  {
    
    // Update allDayDeals and dealTimes accordingly:
    let dealTimeRange = deal.avFrom + "-" + deal.avTo
    if (dealTimeRange == "00:00:00-23:59:00") {
      self.allDayDeals.append(deal.dealID)
    } else {
      let dealIndexes = self.dealTimes[dealTimeRange]
      if (dealIndexes == nil) {
        self.dealTimes[deal.avFrom + "-" + deal.avTo] = [deal.dealID]
      } else {
        if ((dealIndexes!).contains(deal.dealID)) { return } // Return if we've already seen this dealID.
        var mutableDealIndexes = dealIndexes!
        mutableDealIndexes.append(deal.dealID)
        self.dealTimes[deal.avFrom + "-" + deal.avTo] = mutableDealIndexes
      }

    }
    
    
//    let dealIndexes = self.dealTimes[deal.avFrom + "-" + deal.avTo]
//    if (dealIndexes == nil) {
//      self.dealTimes[deal.avFrom + "-" + deal.avTo] = [deal.dealID]
//    } else {
//      if ((dealIndexes!).contains(deal.dealID)) { return } // Return if we've already seen this dealID.
//      var mutableDealIndexes = dealIndexes!
//      mutableDealIndexes.append(deal.dealID)
//      self.dealTimes[deal.avFrom + "-" + deal.avTo] = mutableDealIndexes
//    }

    // Update deal categories set:
    self.dealCategories.insert(deal.dCat)
    
    // Update number of drink / food deals for venue:
    if (deal.fd == 0) {
      self.numFoodDeals += 1
    } else {
      self.numDrinkDeals += 1
    }
  }
  
  func numDealTimeSections() -> Int {
    let numOtherDealRanges = Array(self.dealTimes.keys).count
    return allDayDeals.isEmpty ? numOtherDealRanges : numOtherDealRanges + 1
  }
  
  func numDealsForTimeRange(section: Int) -> Int {
    if (section == 0 && !allDayDeals.isEmpty) {
      return allDayDeals.count
    } else if (allDayDeals.isEmpty) {
      let timeKey = Array(self.dealTimes.keys)[section]
      return self.dealTimes[timeKey]!.count
    } else {
      let timeKey = Array(self.dealTimes.keys)[section - 1]
      return self.dealTimes[timeKey]!.count
    }
  }
  
  func getDealIDForDetailsIndexPath(section: Int, row: Int) -> Int {
    // Show allDayDeals first
    if (section == 0 && !allDayDeals.isEmpty) {
      return allDayDeals[row]
    // Other deals (sections and rows unordered after allDayDeals)
    } else if (allDayDeals.isEmpty) {
      let timeKey = Array(self.dealTimes.keys)[section]
      return self.dealTimes[timeKey]![row]
    } else {
      let timeKey = Array(self.dealTimes.keys)[section - 1]
      return self.dealTimes[timeKey]![row]
    }
  }
  
  func getTimeKeyForDetailsSectionHeader(section: Int) -> String {
    // All Day Deals is presented first in the table:
    if (section == 0 && !allDayDeals.isEmpty) {
      return "00:00:00-23:59:00"
    // If allDayDeals is empty then the first section is from a different dealTime range:
    } else if (allDayDeals.isEmpty) {
      return Array(self.dealTimes.keys)[section]
    // If allDayDeals is not empty then the second section will be the first from dealTimes:
    } else {
      return Array(self.dealTimes.keys)[section - 1]
    }
  }
    
}





