//
//  ViewController.swift
//  VoteApp
//
//  Created by Marko Budal on 07/11/15.
//  Copyright © 2015 Marko Budal. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewWillAppear(animated: Bool) {
        if let user = PFUser.currentUser() {
            
            if user["admin"] as! Bool {
                print("Admin")
                selectedUser = (PFUser.currentUser()?.username)!
                
                let pVC = self.storyboard?.instantiateViewControllerWithIdentifier("adminNav")
                pVC!.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                self.presentViewController(pVC!, animated: true, completion: nil)
                
            } else {
                
                selectedUser = (PFUser.currentUser()?.username)!
                
                let pVC = self.storyboard?.instantiateViewControllerWithIdentifier("navUser")
                pVC!.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                self.presentViewController(pVC!, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: IBAction
    @IBAction func signUpButtonPress(sender: UIButton) {
        self.performSegueWithIdentifier("showSignUpSegue", sender: nil)
    }
    
    
    @IBAction func signInButtonPress(sender: AnyObject) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            let user = PFUser()
            user.username = emailTextField.text!
            user.password = passwordTextField.text!
            
            PFUser.logInWithUsernameInBackground(emailTextField.text!, password: passwordTextField.text!, block: { (user, error) -> Void in
                
                if let err = error {
                    self.displayAlertWithButton("Error from Parse: \(err.description)")
                } else {
                    if user!["admin"] as! Bool {
                        selectedUser = (PFUser.currentUser()?.username)!
                        
                        let pVC = self.storyboard?.instantiateViewControllerWithIdentifier("adminNav")
                        pVC!.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                        self.presentViewController(pVC!, animated: true, completion: nil)
                    } else {
                        
                        selectedUser = (PFUser.currentUser()?.username)!
                        
                        let pVC = self.storyboard?.instantiateViewControllerWithIdentifier("navUser")
                        pVC!.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                        self.presentViewController(pVC!, animated: true, completion: nil)
                    }
                }
            })
            
        } else {
            displayAlertWithButton("Missing some data.")
        }
    }
    
    //MARK: HelperMetod
    func displayAlertWithButton(message: String) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

