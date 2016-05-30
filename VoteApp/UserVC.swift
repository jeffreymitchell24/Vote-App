//
//  UserVC.swift
//  VoteApp
//
//  Created by Marko Budal on 07/11/15.
//  Copyright © 2015 Marko Budal. All rights reserved.
//

import UIKit
import Parse

class UserVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dataFromNoAnswerd:[PFObject] = []
    var dataFromAnswerd:[PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        self.navigationItem.title = selectedUser
        print("selectedUser: \(selectedUser)")
        
    }
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        dataFromNoAnswerd = []
        dataFromAnswerd = []
        getVotes()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logOutBarButtonPress(sender: UIBarButtonItem) {
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            if let err = error {
                print("err: \(err.description)")
            } else {
                let pVC = self.storyboard?.instantiateViewControllerWithIdentifier("startAppNav")
                pVC!.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                self.presentViewController(pVC!, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataFromNoAnswerd.count
        } else {
            return dataFromAnswerd.count
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Non Answer"
        } else {
            return "Answered"
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("adminCell") as! adminCell
        let voteData:PFObject!
        
        if indexPath.section == 0 {
           voteData = dataFromNoAnswerd[indexPath.row]
        } else {
            voteData = dataFromAnswerd[indexPath.row]
        }
        
        cell.question.text = "\(voteData[voteQuestion])"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    //MARK: TableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            performSegueWithIdentifier("userVoteSegue", sender: nil)
        } else {
            performSegueWithIdentifier("displayVoteUserSegue", sender: nil)
        }
    }
    
    //MARK: Helper Methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayVoteUserSegue" {
            let displayVote = segue.destinationViewController as! AdminVoteDisplayVC
            let indexPath = tableView.indexPathForSelectedRow!
//            print("Vote to dis: \(dataFromAnswerd[indexPath.row])")
            displayVote.vote = dataFromAnswerd[indexPath.row]
            displayVote.sendFromAdmin = false
        
        } else if segue.identifier == "userVoteSegue" {
            let answerVote = segue.destinationViewController as! UserVoteVC
            let indexPath = tableView.indexPathForSelectedRow!
//            print("Vote to dis: \(dataFromNoAnswerd[indexPath.row])")
            answerVote.vote = dataFromNoAnswerd[indexPath.row]
        }
    }
    
    func getVotes(){
        let query = PFQuery(className: "Vote")
        query.findObjectsInBackgroundWithBlock { (votes, error) -> Void in
            if let err = error {
                print("Error: \(err.description)")
            } else {
                //self.tableView.reloadData()
                let user = PFUser.currentUser()
                for vote in votes! as [PFObject] {
//                    print("Vote: \(vote)")
//                    print("USer: \(user!)")
                    
                    var insert = true
                    for ans in user!["answered"] as! [[String]]{
                        print("Ans: \(ans)")
                        if !ans.isEmpty {
                            if vote.objectId == ans[0] {
                                self.dataFromAnswerd.append(vote)
                                insert = false
                            }
                        }
                    }
                    
                    if insert {
                        self.dataFromNoAnswerd.append(vote)
                    }
                }
                self.tableView.reloadData()
                
            }
        }
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
