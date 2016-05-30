//
//  AdminVC.swift
//  VoteApp
//
//  Created by Marko Budal on 07/11/15.
//  Copyright © 2015 Marko Budal. All rights reserved.
//

import UIKit
import Parse

class AdminVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var dataFromServer:[PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        self.navigationItem.title = selectedUser
        print("selectedUser: \(selectedUser)")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadAdminView:", name: "reloadAdminViewTable", object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        dataFromServer = []
        updateTable()
    }
    
    func reloadAdminView(notification: NSNotification) {
        print("Notification")
        dataFromServer = []
        updateTable()
    }
    
    //MARK: IBAction
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

    @IBAction func addVoteButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("addVoteSeque", sender: nil)
    }
    
    //MARK: UITableViewDataSourse
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFromServer.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("adminCell") as! adminCell
        
        let voteData = dataFromServer[indexPath.row]
        cell.date.text = "10.12"
        cell.question.text = "\(voteData[voteQuestion]) \nAnswerd: \(voteData[voteNumber])"
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("displayVoteSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayVoteSegue" {
            let displayVote = segue.destinationViewController as! AdminVoteDisplayVC
            let indexPath = tableView.indexPathForSelectedRow!
            print("Vote to dis: \(dataFromServer[indexPath.row])")
            displayVote.vote = dataFromServer[indexPath.row]
            displayVote.sendFromAdmin = true
        }
    }

    //MARK: Helper Message
    func updateTable() {
        let query = PFQuery(className: "Vote")
        query.findObjectsInBackgroundWithBlock { (votes, error) -> Void in
            if let err = error {
                print("Error: \(err.description)")
            } else {
                self.dataFromServer = votes!
                self.tableView.reloadData()
                for vote in votes! as [PFObject] {
                    print("Vote: \(vote)")
                }
                
            }
        }
    }

}

class adminCell: UITableViewCell {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var date: UILabel!
}
