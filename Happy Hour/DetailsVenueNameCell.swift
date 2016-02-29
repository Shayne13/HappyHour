//
//  DetailsVenueNameCell.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 9/8/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class DetailsVenueNameCell: UITableViewCell {

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.userInteractionEnabled = false
  
    self.title.font = UIFont(name: "HelveticaNeue", size: 20)
    self.subtitle.font = UIFont(name: "HelveticaNeue-LightItalic", size: 16)
    self.subtitle.textColor = UIColor.grayColor()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  @IBOutlet weak var title: UILabel!
  
  @IBOutlet weak var subtitle: UILabel!
  
  
}
