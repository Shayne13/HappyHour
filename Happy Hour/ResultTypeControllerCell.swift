//
//  ResultTypeControllerCell.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 8/31/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class ResultTypeControllerCell: UITableViewCell
{
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    resultTypeController.selectedSegmentIndex = (Defaults.getCellType() ? 0 : 1)
  }

  override func setSelected(selected: Bool, animated: Bool)
  {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  @IBOutlet weak var resultTypeController: UISegmentedControl!

}
