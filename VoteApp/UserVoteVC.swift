//
//  UserVoteVC.swift
//  VoteApp
//
//  Created by Marko Budal on 08/11/15.
//  Copyright © 2015 Marko Budal. All rights reserved.
//

import UIKit
import Parse


class UserVoteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var answersDisplay:[[String]] = []
    var vote:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        answersDisplay = vote["Answer"] as! [[String]]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return answersDisplay.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("queCell") as! questionCell
            cell.question.text = "\(vote[voteQuestion])"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ansCell") as! answersCell
            let data = answersDisplay[indexPath.row]
            print(data)
            cell.answer.tag = Int(data[2])!
            cell.answer.setTitle(data[0], forState: UIControlState.Normal)
            
            return cell
        }
    }
    
    @IBAction func AnswerButtonPressed(sender: UIButton) {
        
        print("tag: \(sender.tag)")
        //print("Before push1: \(answersDisplay)")
        var x = 0
        for var data in answersDisplay {
            if Int(data[2]) == sender.tag {
                var numAns = Int(data[1])!
                numAns += 1
                data[1] = "\(numAns)"
                answersDisplay[x] = data
            }
            x += 1
        }
        
       // print("Before push2: \(answersDisplay)")
        
        let queryVote = PFQuery(className: "Vote")
        let idObj = vote.objectId!
        print("OB: \(idObj)")
        queryVote.getObjectInBackgroundWithId(idObj) {
            (updateVote: PFObject?, error:NSError?) -> Void in
            
            if let upVote = updateVote {
                var numAns = upVote[voteNumber] as! Int
                numAns += 1
                upVote[voteNumber] = numAns
                upVote["Answer"] = self.answersDisplay
                
                upVote.saveInBackground()
            }
        }
        
        let idUser = PFUser.currentUser()?.objectId!
        print("isU: \(idUser!)")
        let queryUser = PFUser(withoutDataWithObjectId: idUser!)
    
        var data = queryUser["answered"] as! [[String]]
        
        let d = ["\(self.vote.objectId!)", "\(sender.tag)"]
        data.append(d)
        queryUser["answered"] = data
        queryUser.saveInBackground()
                
        self.navigationController?.popToRootViewControllerAnimated(true)
        
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

class questionCell: UITableViewCell {
    
    @IBOutlet weak var question: UILabel!
}

class answersCell: UITableViewCell {
    
    @IBOutlet weak var answer: UIButton!
 
}
