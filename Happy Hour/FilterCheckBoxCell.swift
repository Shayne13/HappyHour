//
//  FilterCheckBoxCell.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 8/31/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class FilterCheckBoxCell: UITableViewCell
{

  override func awakeFromNib()
  {
    super.awakeFromNib()
    self.title.font = UIFont(name: "HelveticaNeue-Light", size: 16)
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  
  @IBOutlet weak var title: UILabel!
  
}
