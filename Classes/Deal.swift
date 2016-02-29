//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import Foundation

public class Deal
{
  
  var dealID: Int = -1
  var businessID: Int = -1
  var dNameS: String = ""
  var value: Double = -1.0
  var dOp: Int = -1
  var votes: Int = -1
  var bName: String = ""
  var address: String = ""
  var bClass1: Int = -1 // 0 -> No associated class
  var bClass2: Int = -1 // 0 -> No associated class
  var bClass3: Int = -1 // 0 -> No associated class
  var city: Int = -1
  var bType: Int = -1
  var dCat: Int = -1
  var patio: Int = -1
  var pt: Int = -1
  var tv: Int = -1
  var dType: Int = -1
  var avFrom: String = ""
  var avTo: String = ""
  var phone: String = ""
  var website: String = ""
  var fd: Int = -1
  var longitude: Double = -1.0
  var latitude: Double = -1.0
  var logo: String? = nil // can be <null>
  
  
  // MARK: Deal Init via JSON Parsing:
  
  init?(data: NSDictionary?) {
      
    if let dealID = data?.valueForKey(DealKeys.dealID) as? String {
      if let businessID = data?.valueForKey(DealKeys.businessID) as? String {
        if let dNameS = data?.valueForKey(DealKeys.dNameS) as? String {
          if let value = data?.valueForKey(DealKeys.value) as? String {
            if let dOp = data?.valueForKey(DealKeys.dOp) as? String {
              if let votes = data?.valueForKey(DealKeys.votes) as? String {
                if let bName = data?.valueForKey(DealKeys.bName) as? String {
                  if let address = data?.valueForKey(DealKeys.address) as? String {
                    if let bClass1 = data?.valueForKey(DealKeys.bClass1) as? String {
                      if let bClass2 = data?.valueForKey(DealKeys.bClass2) as? String {
                        if let bClass3 = data?.valueForKey(DealKeys.bClass3) as? String {
                          if let city = data?.valueForKey(DealKeys.city) as? String {
                            if let bType = data?.valueForKey(DealKeys.bType) as? String {
                              if let dCat = data?.valueForKey(DealKeys.dCat) as? String {
                                if let patio = data?.valueForKey(DealKeys.patio) as? String {
                                  if let pt = data?.valueForKey(DealKeys.pt) as? String {
                                    if let tv = data?.valueForKey(DealKeys.tv) as? String {
                                      if let dType = data?.valueForKey(DealKeys.dType) as? String {
                                        if let avTo = data?.valueForKey(DealKeys.avTo) as? String {
                                          if let avFrom = data?.valueForKey(DealKeys.avFrom) as? String {
                                            if let phone = data?.valueForKey(DealKeys.phone) as? String {
                                              if let website = data?.valueForKey(DealKeys.website) as? String {
                                                if let fd = data?.valueForKey(DealKeys.fd) as? String {
                                                  
                                                  self.dealID = Int(dealID)!
                                                  self.businessID = Int(businessID)!
                                                  self.dNameS = dNameS
                                                  self.value = (value as NSString).doubleValue
                                                  self.dOp = Int(dOp)!
                                                  self.votes = Int(votes)!
                                                  self.bName = bName
                                                  self.address = address
                                                  self.bClass1 = Int(bClass1)!
                                                  self.bClass2 = Int(bClass2)!
                                                  self.bClass3 = Int(bClass3)!
                                                  self.city = Int(city)!
                                                  self.bType = Int(bType)!
                                                  self.dCat = Int(dCat)!
                                                  self.patio = Int(patio)!
                                                  self.pt = Int(pt)!
                                                  self.tv = Int(tv)!
                                                  self.dType = Int(dType)!
                                                  self.avTo = avTo
                                                  self.avFrom = avFrom
                                                  self.phone = phone
                                                  self.website = website
                                                  self.fd = Int(fd)!
                                                  if let latitude = data?.valueForKey(DealKeys.lat) as? NSString {
                                                    self.latitude = latitude.doubleValue
                                                  }
                                                  if let longitude = data?.valueForKey(DealKeys.lng) as? NSString {
                                                    self.longitude = longitude.doubleValue
                                                  }
                                                  if let logo = data?.valueForKey(DealKeys.logo) as? String {
                                                    self.logo = logo
                                                  }
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
                }
              }
            }
          }
        }
      }
    }
//    println("fail: \(data)")
    // TODO: Check if we're ever failing.
    return nil
  }
  
//  var description: String? {
//    get {
//      return "dealID: \(self.dealID), businessID: \(self.businessID), logo: \(self.logo)"
//    }
//  }
  // MARK: - JSON Data Dictionary Keys:
  
  struct DealKeys {
    static let dealID = "dealID"
    static let businessID = "businessID"
    static let dNameS = "dNameS"
    static let value = "value"
    static let dOp = "dOp"
    static let votes = "votes"
    static let bName = "bName"
    static let address = "address"
    static let bClass1 = "bClass1"
    static let bClass2 = "bClass2"
    static let bClass3 = "bClass3"
    static let city = "city"
    static let bType = "bType"
    static let dCat = "dCat"
    static let patio = "patio"
    static let pt = "pt"
    static let tv = "tv"
    static let dType = "dType"
    static let avFrom = "avFrom"
    static let avTo = "avTo"
    static let phone = "phone"
    static let website = "website"
    static let fd = "f-d"
    static let lat = "lat"
    static let lng = "lng"
    static let logo = "logo"
  }
  
  
  
}
