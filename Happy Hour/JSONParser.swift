//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import Foundation

class JSONParser
{
    
  enum ParseError: ErrorType
  {
    case InvalidJSON
  }
  
  
  
  // Parses JSON for any basic field with return form [Int: String].
  // IE one of 'dType', 'dClass', 'bClass'.
  func parseBasicField(data: NSData) -> [Int: String]
  {
    var results = [Int: String]()
    
    do {
      let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
      if let status = json!["status"] as? Int {
        try verifyStatus(status)
      // println("Status: \(status)")
        if let data = json!["data"] as? NSArray {
          for (index, type) in data.enumerate() {
            if let name = type["name"] as? String {
              results[index + 1] = name
            }
          }
        }
      }
    } catch {
      print("Error unpacking JSON")
    }
    
    return results

  }
  
  private func verifyStatus(status: Int) throws {
//    print(status)
    do {
      if (status == 3) {
        throw ParseError.InvalidJSON
      }
    }
  }
  
  // Parses JSON for any basic field with return form [Int: (String, String)].
  // IE either 'dOp' or 'bType'.
  func parseBasicTupleField(data: NSData, detailName: String) -> [Int: (String, String)]
  {
    var results = [Int: (String, String)]()
    
    do {
      let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
      if let status = json!["status"] as? Int {
        try verifyStatus(status)
        if let data = json!["data"] as? NSArray {
          for (index, type) in data.enumerate() {
            if let name = type["name"] as? String {
              if let detail = type[detailName] as? String {
                results[index + 1] = (name, detail)
              }
            }
          }
        }
      }
    } catch {
      print("Error unpacking JSON")
    }
    return results
  }
    
  // Parse JSON for a SEARCH Request (Returns Deals).
  func parseDeals(data: NSData) -> ([Int: Deal], [Int: Venue])
  {
    var deals = [Int: Deal]()
    var venues = [Int: Venue]()
    
    do {
      let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
      if let status = json!["status"] as? Int { // If status is 3, no results! TODO
        try verifyStatus(status)
        //println("status: \(status)")
        if let data = json!["data"] as? NSArray {
          for JSONdeal in data {
            if let deal = Deal(data: JSONdeal as? NSDictionary)
            {
              deals[deal.dealID] = deal
              venues[deal.businessID] = updateVenuesWithDeal(venues, deal: deal)
            }
          }
        }
      }
    } catch {
      print("Error unpacking JSON")
    }
    return (deals, venues)
  }
  
  // Get the Venue for the Deal, then update its member variables accordingly.
  private func updateVenuesWithDeal(venues: [Int: Venue], deal: Deal) -> Venue
  {
    var venue = venues[deal.businessID]
    if (venue == nil)
    {
      venue = Venue(deal: deal)
    }
    venue!.updateWithDeal(deal)
    return venue!
  }
  
  func parseVenue(data: NSData) -> Venue?
  {
    do {
      let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
      if let status = json!["status"] as? Int {
        try verifyStatus(status)
        if let data = json!["data"] as? NSArray {
          if let venue = Venue(data: data[0] as? NSDictionary) {
            return venue
          }
        }
      }
    } catch {
      print("Error unpacking JSON")
    }
    return nil
  }
  
  
    func parseLocations(data: NSData) -> ([Int: Location], [Int: [Int]], [String])
    {
      
      var results = [Int: Location]()
      var cityIndexesByState = [String: [Int]]()
      var districtIndexesByCity = [Int: [Int]]()
      var listOfStates = [String]()

      do {
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
        if let status = json!["status"] as? Int {
          try verifyStatus(status)
          if let data = json!["data"] as? NSArray {
            for (_, JSONlocation) in data.enumerate() {
              if let loc = Location(data: JSONlocation as? NSDictionary) {
                if loc.parent == 1 && loc.sub == 1 {
                  print("WARNING NOTE: Location \(loc) is both a parent city and a sub city. Code doesn't work for this.")
                }
                results[loc.cityID] = loc
                if loc.sub == 0 { // Is a city:
                  if cityIndexesByState[loc.state] == nil {
                    // NB: Only adds states to state list via cities.
                    cityIndexesByState[loc.state] = [Int]()
                    listOfStates.append(loc.state)
                  }
                  cityIndexesByState[loc.state]!.append(loc.cityID)
                } else { // Is district of a city:
                  if districtIndexesByCity[loc.reference] == nil {
                    districtIndexesByCity[loc.reference] = [Int]()
                  }
                  districtIndexesByCity[loc.reference]!.append(loc.cityID)
                }
              }
            }
          }
        }
      } catch {
        print("Error unpacking JSON")
      }
      
      var orderedLocations = [Int: [Int]]()
      for stateIndex in 0..<listOfStates.count {
        for cityID in cityIndexesByState[listOfStates[stateIndex]]! {
          if orderedLocations[stateIndex] == nil {
            orderedLocations[stateIndex] = [Int]()
          }
          orderedLocations[stateIndex]!.append(cityID)
          if let districtIDs = districtIndexesByCity[cityID] {

            let alphabeticallySortedDistricts = districtIDs.sort {
              results[$0]!.name.localizedCaseInsensitiveCompare(results[$1]!.name) == NSComparisonResult.OrderedAscending
            }
            orderedLocations[stateIndex]! += alphabeticallySortedDistricts
          }
        }
      }
      return (results, orderedLocations, listOfStates)
    }
    
}


