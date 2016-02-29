//
//  CurrentlyOpenToggleCell.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 8/31/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class CurrentlyOpenToggleCell: UITableViewCell
{

  private var originalSwitchStatus = Bool()
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    currentlyOpenSwitch.setOn(Defaults.getCurrentlyOpenStatus(), animated: true)
    originalSwitchStatus = Defaults.getCurrentlyOpenStatus()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  
  @IBOutlet weak var currentlyOpenLabel: UILabel!
  
  @IBOutlet weak var currentlyOpenSwitch: UISwitch!
  
  @IBAction func currentlyOpenToggle(sender: UISwitch)
  {
    // Nothing for now - not until user presses 'Done'
  }
  
  func didToggleSwitch() -> Bool
  {
    if (originalSwitchStatus == currentlyOpenSwitch.on)
    {
      return false
    }
    return true
  }
  
}
