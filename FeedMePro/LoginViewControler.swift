//
//  LoginViewControler.swift
//  FeedMePro
//
//  Created by jevy on 19/03/2016.
//  Copyright © 2016 jevy.wf. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: UIButton) {
        
        self.performSegueWithIdentifier("loginSegue", sender: self)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
        self.view.endEditing(true)
    }
}