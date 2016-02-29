//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import Foundation

public class Location
{
    
  var cityID: Int = -1
  var parent: Int = -1
  var reference: Int = -1
  var sub: Int = -1
  var name: String = ""
  var state: String = ""
  var country: String = ""


  // MARK: Location Init via JSON Parsing:

  init?(data: NSDictionary?) {
      
    if let cityID = data?.valueForKey(LocationKeys.cityID) as? String {
      if let parent = data?.valueForKey(LocationKeys.parent) as? String {
        if let reference = data?.valueForKey(LocationKeys.reference) as? String {
          if let sub = data?.valueForKey(LocationKeys.sub) as? String {
            if let name = data?.valueForKey(LocationKeys.name) as? String {
              if let state = data?.valueForKey(LocationKeys.state) as? String {
                if let country = data?.valueForKey(LocationKeys.country) as? String {
                    
                  self.cityID = Int(cityID)!
                  self.parent = Int(parent)!
                  self.reference = Int(reference)!
                  self.sub = Int(sub)!
                  self.name = name
                  self.state = state
                  self.country = country
                  return
                    
                }
              }
            }
          }
        }
      }
    }
    return nil
  }


  // MARK: - JSON Data Dictionary Keys:

  struct LocationKeys {
    static let cityID = "cityID"
    static let parent = "parent"
    static let reference = "reference"
    static let sub = "sub"
    static let name = "name"
    static let state = "state"
    static let country = "country"
  }
  
}