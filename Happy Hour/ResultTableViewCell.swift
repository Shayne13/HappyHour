//
//  Happy Hour
//
//  Created by Shayne on 2015-03-11.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    /*override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }*/

    /*override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/
    
    //put changing of labels here
    //store values of view in here for labels
    
  @IBOutlet weak var logo: UIImageView!
    
  @IBOutlet weak var deal: UILabel!

  @IBOutlet weak var venue: UILabel!
    
  @IBOutlet weak var address: UILabel!
  
  @IBOutlet weak var dealRating: UILabel!
  
  @IBOutlet weak var distanceToVenue: UILabel!
  
}
