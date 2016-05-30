//
//  AdminVoteDisplayVC.swift
//  VoteApp
//
//  Created by Marko Budal on 08/11/15.
//  Copyright © 2015 Marko Budal. All rights reserved.
//

import UIKit
import Parse

class AdminVoteDisplayVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var vote:PFObject!
    var sendFromAdmin:Bool!
    var dataAnswer:[[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        //print("Vote: \(vote)")
        dataAnswer = vote["Answer"] as! [[String]]
        let first = [vote["question"] as! String, "\(vote[voteNumber] as! Int)"]
        dataAnswer.insert(first, atIndex: 0)
        
        print(dataAnswer)
        //displaAnswers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAnswer.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        let data = dataAnswer[indexPath.row]
        
        var num = Int(data[1])
        if num > 0 {
            num = num! * 100 / (vote[voteNumber] as! Int)
        }
        
        if sendFromAdmin! {
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Question: \(data[0]),  Answered: \(vote[voteNumber] as! Int)"
            } else {
                cell?.textLabel?.text = "\(data[0]) - \(num!)% "
            }
        } else {
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Question: \(data[0]), - Answered: \(vote[voteNumber] as! Int)"
            } else {
                print(PFUser.currentUser()!["answered"])
                print(data[2])
                print(vote.objectId!)
                var noSelection = true
                for ans in PFUser.currentUser()!["answered"] as! [[String]] {
                    print("ANS: \(ans)")
                    if ans[0] == vote.objectId! {
                        if ans[1] == data[2] {
                            cell?.textLabel?.text = "MY Selection: \(data[0]) - \(num!)%"
                            noSelection = false
                        }
                    }
                }
                
                if noSelection {
                    cell?.textLabel?.text = "\(data[0]) - \(num!)%"
                }
                
                
                
            }
        }
        
        
        return cell!
    }
    
    func displaAnswers() {
//        questionLabel.text = "\(vote[voteQuestion]) \nAnswers: \(vote[voteNumber])"
//
//        let numA = vote[voteNumberA] as! Int
//        let numB = vote[voteNumberB] as! Int
//        let numC = vote[voteNumberC] as! Int
//        let numD = vote[voteNumberD] as! Int
//        
//        if numA > 0 {
//            let resA =  numA * 100 / (vote[voteNumber] as! Int)
//            answerALabel.text = "\(vote[voteAnswerA]) - \(resA)%"
//        } else {
//            answerALabel.text = "\(vote[voteAnswerA]) - 0%"
//        }
//        
//        if numB > 0 {
//            let resB = numB * 100 / (vote[voteNumber] as! Int)
//            answerBLabel.text = "\(vote[voteAnswerB]) - \(resB)%"
//        } else {
//            answerBLabel.text = "\(vote[voteAnswerB]) - 0%"
//        }
//        
//        if numC > 0 {
//            let resC =  numC * 100 / (vote[voteNumber] as! Int)
//            answerCLabel.text = "\(vote[voteAnswerC]) - \(resC)%"
//        } else {
//            answerCLabel.text = "\(vote[voteAnswerC]) - 0%"
//        }
//        
//        if numD > 0 {
//            let resD =  numD * 100 / (vote[voteNumber] as! Int)
//            answerDLabel.text = "\(vote[voteAnswerD]) - \(resD)%"
//        } else {
//            answerDLabel.text = "\(vote[voteAnswerD]) - 0%"
//        }
        
       
//
//        let resB = Int(vote[voteNumber]! as! NSNumber) / Int(vote[voteNumberB]! as! NSNumber)
//        answerALabel.text = "\(vote[voteAnswerB]) - \(resB)"
//        
//        let resC = Int(vote[voteNumber]! as! NSNumber) / Int(vote[voteNumberC]! as! NSNumber)
//        answerALabel.text = "\(vote[voteAnswerB]) - \(resC)"
//        
//        let resD = Int(vote[voteNumber]! as! NSNumber) / Int(vote[voteNumberD]! as! NSNumber)
//        answerALabel.text = "\(vote[voteAnswerB]) - \(resD)"
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
