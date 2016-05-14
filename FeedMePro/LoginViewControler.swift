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
        self.setViewBar(self)
        self.setViewBackground(self)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: UIButton) {
        NSLog("username: %@, password: %@", email.text!, password.text!)
        
        let hashPassword = Security.md5(string: password.text!)
        NSLog("hash password: %@", hashPassword)
        
        let urlString: String = FeedMe.Path.TEXT_HOST + "restaurants/login?email=\(email.text!)&pwd=\(hashPassword)"
        
        validateUserLogin(urlString)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func displayMessage(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonClicked(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    @IBAction func signInButtonClicked(sender: UIButton) {
//        NSLog("username: %@, password: %@", email.text!, password.text!)
//        
//        let verifyUserLoginResult = verifyUserLogin(email.text, inputPassword: password.text)
//        
//        if verifyUserLoginResult.statusCode == 0 {
//            email.text = ""
//            password.text = ""
//            email.becomeFirstResponder()
//            
//            displayMessage(verifyUserLoginResult.description)
//        } else {
//            dismissViewControllerAnimated(true, completion: nil)
//        }
//    }
    
    func validateUserLogin(urlString: String) {
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (myData, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                let json: NSDictionary
                
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(myData!, options: .AllowFragments) as! NSDictionary
                    print(json)
                    if let _ = json["id"] as? Int {
                        
                            NSLog("Login Success!")
//                            self.loginStatus = true
                            FeedMe.Variable.userInLoginState = true
                            
                            FeedMe.Variable.restaurantID=json["id"] as? Int
                            FeedMe.Variable.restaurantName=json["name"] as? String
                            FeedMe.Variable.userInLoginState=true
//                            self.dismissViewControllerAnimated(true, completion: nil)
                            let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("init")
                            self.presentViewController(nextView!, animated: true, completion:nil)
                        
                    }else{
                        NSLog("Login Fail!+++")
                        self.displayMessage("Incorrect email address or password!")
                    }
                } catch _ {
                    self.displayMessage("Incorrect email address or password!")
                    print(error)
                    
                }
                
            })
        }
        task.resume()
    }
    

}