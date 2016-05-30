//
//  AddVoteVC.swift
//  VoteApp
//
//  Created by Marko Budal on 07/11/15.
//  Copyright © 2015 Marko Budal. All rights reserved.
//

import UIKit
import Parse

protocol testDelegate {
    func myDelegate()
}

var answers = [["Placeholder" : "Answer:", "Answer" :""]]

class AddVoteVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionTextField: UITextField!
    
    var delegate: testDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTable:", name: "reloadTableName", object: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        questionTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func reloadTable(notification: NSNotification) {
        print("Notification")
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addNewAnswer(sender: UIButton) {
        let newTF = ["Placeholder" : "Answer:", "Answer" :""]
        answers.append(newTF)
        tableView.reloadData()
    }
    
    @IBAction func removeAnswer(sender: UIButton) {
        
        
    }
    
    @IBAction func saveVoteButtonPress(sender: AnyObject) {

        var answersParseTable:[[String]] = []
        var i = 0
        for ans in answers {
            let x = [ans["Answer"]!, "0", "\(i)"]
            answersParseTable.append(x)
            i += 1
        }
        
        let vote = PFObject(className: "Vote")
       
        vote[voteQuestion] = questionTextField.text!
        vote[voteNumber] = 0
        vote["Answer"] = answersParseTable
        vote[voteDete] = NSDate()
        
        //Send notification:
        let pushQuery = PFInstallation.query()
        //set TimeIntervall
        let interval = Double(60 * 60) //(24h) * 24 -> * 7 -> 7 days
        
        let data = [
            "alert":"You receive a new Question.",
            "sound": "default",
            "badge": "Increment"
        ]
        
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        
        push.expireAfterTimeInterval(interval)
        push.setData(data as [NSObject : AnyObject])
        push.sendPushInBackground()
        
        vote.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if let err = error {
                print("Error: \(err.description)")
            } else {
                if succeeded {
                    print("Save success")
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadAdminViewTable", object: nil)
                    answers = [["Placeholder" : "Answer:", "Answer" :""]]
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("Save problem")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        
    }
    
    @IBAction func cancelButtonPress(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("addAnswerCell") as! addAnswersCell
        let data = answers[indexPath.row]
        
        cell.configure(text: data["Answer"]!, placeholder: data["Placeholder"]!, tag: indexPath.row)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        
    }
    
//    //UITextFieldDelegate
//    func textFieldDidEndEditing(textField: UITextField) {
//        print("End")
//        resignFirstResponder()
//        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableName", object: nil)
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        resignFirstResponder()
//        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableName", object: nil)
//        return true
//    }

}

class addAnswersCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var buttonX: UIButton!
    
    func configure(text text:String, placeholder:String, tag: Int){
        answerTextField.delegate = self
        
        answerTextField.tag = tag
        buttonX.tag = tag
        answerTextField.text = text
        answerTextField.placeholder = placeholder
    
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignFirstResponder()
//        textFieldDidEndEditing(textField)
        return true
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        textFieldDidEndEditing(textField)
        print("textFieldShouldEndEditing")
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableName", object: nil)

        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newTF = ["Placeholder" : "Answer:", "Answer" : "\(textField.text! + string)"]
        print("tag: \(textField.tag)")
        answers[textField.tag] = newTF
        buttonX.highlighted = false
        
        return true
    }


    @IBAction func removeCellButtonPress(sender: UIButton) {

        print("TAG: \(sender.tag)")
        print("ans: \(answers.count)")
        print("H: \(sender.highlighted)")
//        textFieldDidEndEditing(answerTextField)
        answers.removeAtIndex(sender.tag)
        answers = [["Placeholder" : "Answer:", "Answer" :""]]
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableName", object: nil)
        
    }
    
}