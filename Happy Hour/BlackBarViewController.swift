//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class BlackBarViewController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()
//    self.navigationBar.barStyle = UIBarStyle.Black
    self.navigationBar.tintColor = UIColor.whiteColor()
//    self.navigationBar.barTintColor = UIColor(red: 0.22, green: 0.22, blue: 0.24, alpha: 1.0)
//    self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
//    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

    // Do any additional setup after loading the view.
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
