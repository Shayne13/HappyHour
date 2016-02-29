//
//  SegmentedViewController.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 6/29/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class SegmentedViewController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    self.navigationController?.hidesBarsOnSwipe = true
//    navigationController?.navigationBar.hidden = true
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  */

}





//    let filterIcon = UIImage(named: "filter_icon")!
//    let backIcon = UIImage(named: "checkbox")
//
//    let backItem = UIBarButtonItem(image: backIcon, style: .Plain, target: nil, action: nil)
//    self.navigationItem.backBarButtonItem = backItem


//    self.navigationBar.appearance().setBackgroundIndicatorImage(backIcon)
//    UIBarButtonItem.appearance().setBackButtonBackgroundImage(backIcon, forState: .Normal, barMetrics: .Default)
//    self.navigationBar.backItem!.backBarButtonItem!.setBackButtonBackgroundImage(backIcon, forState: .Normal, barMetrics: .Default)
//    let backItem = UIBarButtonItem(image: UIImage(named: "checkbox"), style: .Plain, target: nil, action: nil)
//    navigationItem.backBarButtonItem!.setBackButtonBackgroundImage(UIImage(named: "checkbox"), forState: .Normal, barMetrics: .Default)