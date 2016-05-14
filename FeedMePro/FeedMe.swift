//
//  FeedMe.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 19/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

struct FeedMe {
    
    struct Path {
        static let TEXT_HOST = "http://ec2-52-27-149-51.us-west-2.compute.amazonaws.com:8080/"
//        static let TEXT_HOST = "http://localhost:8080/"
        static let PICTURE_HOST = "http://ec2-52-27-149-51.us-west-2.compute.amazonaws.com:8080/"
    }
    
    struct Variable {
        static var userID: Int?
        static var restaurantID: Int?
        static var restaurantName: String?
        static var dishID: Int?
        static var images: [String: UIImage]?
        static var dishes: [Int: Dish]!
        static var userInLoginState: Bool?
        
    }
    static var transColor4 = UIColor(red: 255/225, green: 255/255, blue: 255/255, alpha: 0.4)
    static var transColor7 = UIColor(red: 255/225, green: 255/255, blue: 255/255, alpha: 0.7)
    static var redColor = UIColor(red: 194/255, green: 45/255, blue: 36/255, alpha: 1)
    static var grayColor = UIColor(red: 153/225, green: 153/255, blue: 153/255, alpha: 1)
    
}


enum DishType: String {
    case Staple = "Staple"
    case Soup = "Soup"
    case Dessert = "Dessert"
    case Drinks = "Drinks"
    case Others = "Others"
}