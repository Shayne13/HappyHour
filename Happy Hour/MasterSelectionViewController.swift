//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class MasterSelectionViewController: UIViewController {
  
  let client = Client.Instance.singleton
  
  @IBAction func toggleDrinks(sender: ToggleOption) {
    drinks = !drinks
//    if drinks { drinks = false }
//    else { drinks = true }
  }
    
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var backgroundImg: UIImageView!
  @IBOutlet weak var toggleView: ToggleView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    backgroundImg.contentMode = .ScaleAspectFill
    backgroundImg.image = UIImage(named: "bg3")
    
    toggleView.sendSubviewToBack(backgroundImg)
    
    self.searchButton.layer.borderWidth = 2
    self.searchButton.layer.borderColor = UIColor.whiteColor().CGColor
    self.searchButton.layer.cornerRadius = 5
    
    client.fetchBasicFields()
    
  }
    
  @IBOutlet weak var locationButton: UIBarButtonItem!
    
  override func viewDidAppear(animated: Bool) {
    
    navigationItem.title = "Happy Hour"
    
        //for future reference
//        let date = NSDate()
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
//        let hour = components.hour
//        let minutes = components.minute
//        
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        let dayOfWeekString = dateFormatter.stringFromDate(date)
//        println(dayOfWeekString)
    
    if client.selectedLocation != nil {
      locationButton.title = client.selectedLocation?.name
    } else {
      locationButton.title = "Location"
    }
        
        
  }
    
  var drinks: Bool = false {
    didSet {
      //println("Drinks set to \(self.drinks)")
      client.Drinks = self.drinks
    }
  }
  var food: Bool = false {
    didSet {
      //println("Food set to \(self.food)")
      client.Food = self.food
    }
  }
  
  
  @IBAction func toggleFood(sender: ToggleFood) {
    food = !food
  }
    
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Display Results" {
      if let _ = segue.destinationViewController.contentViewController as? ResultsViewController {
        
      }
    }
  }
    
    
    
}
