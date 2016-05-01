//
//  Dish.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 19/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

class DishLog {
    
    // MARK: Properties
    var ID: Int
    var shopID: Int?
    var status: Int?
    var dat: NSDate
    
    
    // MARK: Initialization
    init?(ID: Int, shopID: Int?, status: Int?, dat:NSDate) {
        // Initialize stored properties.
        self.ID = ID
        self.status = status
        self.dat = dat
    }
    
}
