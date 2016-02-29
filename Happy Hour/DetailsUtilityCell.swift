//
//  DetailsUtilityCell.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 9/8/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class DetailsUtilityCell: UITableViewCell {

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  @IBOutlet weak var automatedCallButton: UIButton!
  
  @IBOutlet weak var automatedWebLinkButton: UIButton!
  
  @IBOutlet weak var automatedDirectionsButton: UIButton!
  
}
