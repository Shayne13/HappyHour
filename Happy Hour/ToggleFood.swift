//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class ToggleFood: UIButton {

  //images
  let checkedImage = UIImage(named: "foodChecked")
  let uncheckedImage = UIImage(named: "foodUnchecked")
  
  //bool property
  var isChecked: Bool = false {
    didSet {
      if isChecked == true {
        self.setImage(checkedImage, forState: UIControlState.Normal)
      } else {
        self.setImage(uncheckedImage, forState: UIControlState.Normal)
      }
    }
  }
  
  override func awakeFromNib() { //try other places to
    self.addTarget(self, action: "changeButton:", forControlEvents: UIControlEvents.TouchUpInside)
    self.isChecked = false
  }
  
  func changeButton (sender: UIButton) {
    if (sender == self) {
      if isChecked == true {
        isChecked = false
      } else {
        isChecked = true
      }
    }
  }

}
