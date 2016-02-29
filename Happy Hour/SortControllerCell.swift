//
//  SortControllerCell.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 8/31/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class SortControllerCell: UITableViewCell
{

  private var originalSortType = Int()
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    sortTypeController.selectedSegmentIndex = Defaults.getSortType()
    originalSortType = Defaults.getSortType()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  @IBOutlet weak var sortTypeController: UISegmentedControl!
  
  @IBAction func changeSortType(sender: UISegmentedControl)
  {
    // Nothing for now - not until user presses 'Done'
  }
  
  func didChangeSortType() -> Bool
  {
    if (originalSortType == sortTypeController.selectedSegmentIndex)
    {
      return false
    }
    return true
  }
}