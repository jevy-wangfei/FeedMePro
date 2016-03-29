//
//  InitTableViewCell.swift
//  FeedMePro
//
//  Created by jevy on 20/03/2016.
//  Copyright © 2016 jevy.wf. All rights reserved.
//

import UIKit

class InitTableViewCell: UITableViewCell {

    @IBOutlet weak var dishImg: UIImageView!
 
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var offStock: UIButton!

    
    override func awakeFromNib() {
               super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
