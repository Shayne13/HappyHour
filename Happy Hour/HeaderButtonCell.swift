//
//  HeaderButtonCell.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 9/7/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class HeaderButtonCell: UITableViewCell {

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
//    button.backgroundColor = UIColor.clearColor()
//    button.layer.cornerRadius = 5
//    button.layer.borderWidth = 1
//    button.layer.borderColor = UIColor.blackColor().CGColor
    button.titleEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
    
//    let borderAlpha : CGFloat = 0.7
    let cornerRadius : CGFloat = 5.0
    
//    button.frame = CGRectMake(100, 100, 200, 40)
//    button.setTitle("Get Started", forState: UIControlState.Normal)
//    button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    button.backgroundColor = UIColor.clearColor()
    button.layer.borderWidth = 1.0
//    button.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).CGColor
    button.layer.cornerRadius = cornerRadius
    
    
    
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
  
  @IBOutlet weak var title: UILabel!
  
  @IBOutlet weak var button: UIButton!

}
