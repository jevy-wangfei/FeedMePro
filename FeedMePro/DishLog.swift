//
//  Dish.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 19/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

class DishLog : EVObject {
    
    // MARK: Properties
    var dishId: Int
    var restaurantId: Int?
    var available: Int?
    var dat: NSDate
    
    
    // MARK: Initialization
    init?(ID: Int, shopID: Int?, status: Int?, dat:NSDate) {
        // Initialize stored properties.
        self.dishId = ID
        self.available = status
        self.dat = dat
        self.restaurantId = shopID
    }
    
    required init() {
        self.dishId = -1
        self.dat = NSDate()
        self.restaurantId = -1
        
    }
    
}
