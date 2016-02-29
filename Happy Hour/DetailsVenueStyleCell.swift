//
//  DetailsVenueStyleCell.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 9/8/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class DetailsVenueStyleCell: UITableViewCell {

  override func awakeFromNib() {
    super.awakeFromNib()
    self.userInteractionEnabled = false
    
    title.textAlignment = NSTextAlignment.Center
    title.lineBreakMode = NSLineBreakMode.ByWordWrapping
    title.numberOfLines = 0 // '0' means infinite number of lines
    
    title.font = UIFont(name: "HelveticaNeue-Light", size: 16)
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  @IBOutlet weak var title: UILabel!
  
}
