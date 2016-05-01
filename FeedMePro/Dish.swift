//
//  Dish.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 19/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

class Dish {
    
    // MARK: Properties
    var ID: Int
    var shopID: Int?
    var type: String?
    var name: String?
    var description: String?
    var photo: UIImage?
    var ingredient: String?
    var price: Int?
    var discount: Int?
    var flavor: String?
    var sold: Int?
    var status: Int?
    
    
    // MARK: Initialization
    init?(ID: Int, shopID: Int?, type: String?, name: String?, description: String?, photo: UIImage?, ingredient: String?, price: Int?, discount: Int?, flavor: String?, sold: Int?, status: Int?=1) {
        // Initialize stored properties.
        self.ID = ID
        self.shopID = shopID
        self.type = type
        self.name = name
        self.description = description
        self.photo = photo
        self.ingredient = ingredient
        self.price = price
        self.discount = discount
        self.flavor = flavor
        self.sold = sold
        self.status = status
    }
    
    func setPhoto(image: UIImage?) {
        self.photo = image
    }
    
}
