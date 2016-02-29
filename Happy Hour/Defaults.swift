//
//  Defaults.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 8/31/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import Foundation

class Defaults
{
  
  // TODO: Decide between using this static var, and NSUserDefaults.standardUserDefaults(). ...
  static var defaults: NSUserDefaults? = nil
  
  private struct Keys
  {
    static let cellType = "cell_type"
    static let mapType = "map_type"
    static let resultsSortType = "results_sort_type"
    
    struct SearchHistory
    {
      static let resultsSearchHistory = "results_search_history"
      static let locationSearchHistory = "location_search_history"
      static let capacity = 5
    }
    
    struct Filters
    {
      static let currentlyOpen = "currently_open"
      static let dealCategories = "deal_categories"
      static let businessClasses = "business_classes"
    }
  }
  
  // Init UserDefault values to their start-up values
  class func initDefaults()
  {
    defaults = NSUserDefaults.standardUserDefaults()

    if (defaults?.objectForKey(Keys.cellType) == nil) { setCellType(true) } // Deal cells = true; Venue cells = false
    if (defaults?.objectForKey(Keys.mapType) == nil) { setMapType(0) } // Standard map by default
    if (defaults?.objectForKey(Keys.resultsSortType) == nil) { setSortType(0) } // Default result list sort type
    
    if (defaults?.objectForKey(Keys.SearchHistory.resultsSearchHistory) == nil) {
      defaults?.setObject([NSString](), forKey: Keys.SearchHistory.resultsSearchHistory)
    }
    if (defaults?.objectForKey(Keys.SearchHistory.locationSearchHistory) == nil) {
      defaults?.setObject([NSString](), forKey: Keys.SearchHistory.locationSearchHistory)
    }
    
    if (defaults?.objectForKey(Keys.Filters.currentlyOpen) == nil) { setCurrentlyOpenStatus(false) }
    if (defaults?.objectForKey(Keys.Filters.dealCategories) == nil) {
      defaults?.setObject([Int](), forKey: Keys.Filters.dealCategories)
    }
    if (defaults?.objectForKey(Keys.Filters.businessClasses) == nil) {
      defaults?.setObject([Int](), forKey: Keys.Filters.businessClasses)
    }
    
  }
  
  // TYPE SETTINGS:
  
  class func getCellType() -> Bool {
    return NSUserDefaults.standardUserDefaults().boolForKey(Keys.cellType)
  }
  
  class func setCellType(status: Bool) {
    defaults?.setBool(status, forKey: Keys.cellType)
  }
  
  class func getMapType() -> Int {
    return NSUserDefaults.standardUserDefaults().integerForKey(Keys.mapType)
  }
  
  class func setMapType(type: Int) {
    NSUserDefaults.standardUserDefaults().setInteger(type, forKey: Keys.mapType)
  }
  
  class func getSortType() -> Int {
    return NSUserDefaults.standardUserDefaults().integerForKey(Keys.resultsSortType)
  }
  
  class func setSortType(type: Int) {
    NSUserDefaults.standardUserDefaults().setInteger(type, forKey: Keys.resultsSortType)
  }

  // SEARCH HISTORY:
  
  class func getResultsSearchHistory() -> [String]? {
    return getSearchHistory(Keys.SearchHistory.resultsSearchHistory)
  }
  
  class func addResultsSearch(search: String) {
    addToSearchHistory(Keys.SearchHistory.resultsSearchHistory, search: search)
  }
  
  class func getLocationSearchHistory() -> [String]? {
    return getSearchHistory(Keys.SearchHistory.locationSearchHistory)
  }
  
  class func addLocationSearch(search: String) {
    addToSearchHistory(Keys.SearchHistory.locationSearchHistory, search: search)
  }
  
  // FILTERS:
  
  class func getCurrentlyOpenStatus() -> Bool {
    return NSUserDefaults.standardUserDefaults().boolForKey(Keys.Filters.currentlyOpen)
  }
  
  class func setCurrentlyOpenStatus(status: Bool) {
    NSUserDefaults.standardUserDefaults().setBool(status, forKey: Keys.Filters.currentlyOpen)
  }
  
  // Takes a dealCategory index and indicates whether it's filtered out or not
  class func getDealCategoryStatus(index: Int) -> Bool {
    if let dealCategories: AnyObject = NSUserDefaults.standardUserDefaults().arrayForKey(Keys.Filters.dealCategories) {
      let categorySet = dealCategories as! [Int]
      return ((categorySet.isEmpty) || (categorySet.contains(index)))
    }
    return false
  }
  
  // Takes a set of dealCategories for a venue, and indicates whether that venue is filtered out or not (for the ResultsMapView)
  class func getDealCategoryStatus(indexes: Set<Int>) -> Bool {
    if let dealCategories: AnyObject = NSUserDefaults.standardUserDefaults().arrayForKey(Keys.Filters.dealCategories) {
      let categorySet = Set(dealCategories as! [Int])
      return ((categorySet.isEmpty) || (!categorySet.intersect(indexes).isEmpty))
    }
    return false
  }
  
  class func getToggledDealCategories() -> Set<Int> {
    if let dealCategories: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(Keys.Filters.dealCategories) {
      return Set(dealCategories as! [Int])
    }
    return Set<Int>()
  }
  
  class func removeAllDealCategories() {
    NSUserDefaults.standardUserDefaults().removeObjectForKey(Keys.Filters.dealCategories)
  }
  
  class func setDealCategories(indexes: Set<Int>) {
    print("setting deals: \(indexes)")
    NSUserDefaults.standardUserDefaults().setObject(Array(indexes), forKey: Keys.Filters.dealCategories)
  }
  
  class func getBusinessClassStatus(indexes: Set<Int>) -> Bool {
    if let businessClasses = NSUserDefaults.standardUserDefaults().arrayForKey(Keys.Filters.businessClasses) {
      let businessSet = Set(businessClasses as! [Int])
      return ((businessSet.isEmpty) || (!businessSet.intersect(indexes).isEmpty))
    }
    return false
  }
  
  class func getToggledBusinessClasses() -> Set<Int> {
    if let businessClasses = NSUserDefaults.standardUserDefaults().arrayForKey(Keys.Filters.businessClasses) {
      return Set(businessClasses as! [Int])
    }
    return Set<Int>()
  }
  
  class func removeAllBusinessClasses() {
    NSUserDefaults.standardUserDefaults().removeObjectForKey(Keys.Filters.businessClasses)
  }

  class func setBusinessClasses(indexes: Set<Int>) {
    NSUserDefaults.standardUserDefaults().setObject(Array(indexes), forKey: Keys.Filters.businessClasses)
  }
  
  // MARK: - Helper Methods
  
  private class func getSearchHistory(key: String) -> [String]?
  {
    if let searchHistory = NSUserDefaults.standardUserDefaults().objectForKey(key) as? [String]
    {
      return searchHistory
    }
    return nil
  }
  
  private class func addToSearchHistory(key: String, search: String)
  {
    if let searchHistory = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSMutableArray
    {
      if (searchHistory.indexOfObject(search as NSString) == NSNotFound)
      {
        if (searchHistory.count >= Keys.SearchHistory.capacity)
        {
          searchHistory.removeLastObject()
        }
        searchHistory.insertObject(search as NSString, atIndex: 0)
        NSUserDefaults.standardUserDefaults().setObject(searchHistory, forKey: key)
      }
    }
  }

  
}