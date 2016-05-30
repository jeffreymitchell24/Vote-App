//
//  SignUpVC.swift
//  VoteApp
//
//  Created by Marko Budal on 07/11/15.
//  Copyright © 2015 Marko Budal. All rights reserved.
//

import UIKit
import Parse


class SignUpVC: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
//    @IBOutlet weak var setAdminOrUser: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "SignUp"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        userNameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        
//        setAdminOrUser.setOn(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction
    
    @IBAction func signUpButtonPress(sender: UIButton) {
        if userNameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "" {
        
            let user = PFUser()
            user.username = userNameTextField.text!
            user.password = passwordTextField.text!
            user.email = emailTextField.text!
            
            
            user["admin"] = false //setAdminOrUser.on
            user["answered"] = []
            
            
            user.signUpInBackgroundWithBlock({ (succeeded, error) -> Void in
                if let err = error {
                    self.displayAlertWithButton("Error saveing new user. \n \(err.description)")
                } else {
                    selectedUser = (PFUser.currentUser()?.username!)!

                    let installation:PFInstallation = PFInstallation.currentInstallation()
                    installation["user"] = PFUser.currentUser()
//                    installation.addUniqueObjectsFromArray(["Reload", PFUser.currentUser()!.username!], forKey: "channels")
                    installation.saveInBackgroundWithBlock(nil)

                    //go to new screen
                    
//                    if self.setAdminOrUser.on {
//                        
//                        let pVC = self.storyboard?.instantiateViewControllerWithIdentifier("adminNav")
//                        pVC!.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//                        self.presentViewController(pVC!, animated: true, completion: nil)
//                        
//                    } else {
                        let pVC = self.storyboard?.instantiateViewControllerWithIdentifier("navUser")
                        pVC!.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                        self.presentViewController(pVC!, animated: true, completion: nil)
//                    }
                    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
