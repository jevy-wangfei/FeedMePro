//
//  OrderProcessCell.swift
//  FeedMePro
//
//  Created by jevy on 28/04/2016.
//  Copyright © 2016 jevy.wf. All rights reserved.
//

import UIKit

class OrderProcessCell: UITableViewCell {


    
    @IBOutlet weak var orderTime: UILabel!
    
    @IBOutlet weak var currentStatus: UILabel!
    @IBOutlet weak var processOrder: UIButton!
    @IBOutlet weak var totalSpend: UILabel!
    
    @IBOutlet weak var dishCount: UILabel!
    @IBOutlet weak var orderDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
