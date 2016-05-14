//
//  FeedMeAlert.swift
//  FeedMePro
//
//  Created by jevy on 8/05/2016.
//  Copyright © 2016 jevy.wf. All rights reserved.
//

import UIKit

public class FeedMeAlert {
    class func alertSignUpFailure(viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Sign Up Failure", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}