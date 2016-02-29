//
//  DetailsDealCell.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 9/8/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class DetailsDealCell: UITableViewCell {

  override func awakeFromNib() {
    super.awakeFromNib()
    self.userInteractionEnabled = false
    self.title.font = UIFont(name: "HelveticaNeue-Light", size: 16)
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  
  @IBOutlet weak var title: UILabel!
  
  @IBOutlet weak var img: UIImageView!
  
  
}
