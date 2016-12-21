//
//  NMSViewController.swift
//  NewSNMPPoller
//
//  Created by Kent Taylor on 12/8/16.
//  Copyright © 2016 Cybernewton Systems. All rights reserved.
//

import UIKit

class NMSViewController: UIViewController {
    // OBJECTS
    
    var group : NMSGroup?
    
    // OUTLETS
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    var messageOffset : Int = 0
    
    var messageTableVC : EmbeddedMessageListVC?
    @IBOutlet weak var messageTableView: UIView!
    
    // ACTIONS
    @IBAction func refreshButtonAction(_ sender: Any) {
        // Resets the offset and returns the first page of newly-updated entries
        messageOffset = 0
        prevButton.isEnabled = false
        group?.refreshMessages(
            offset: messageOffset,
            callback: {
                DispatchQueue.main.async {
                    self.msgCallback()
                }
                guard let count : Int = self.group?.messages.count else{
                    return
                }
                if count < 10{
                    self.nextButton.isEnabled = false
                }
        })
    }
    
    @IBAction func nextButtonPress(_ sender: Any) {
        prevButton.isEnabled = true
        messageOffset += 10
        group?.refreshMessages(
            offset: messageOffset,
            callback: {
                DispatchQueue.main.async {
                    self.msgCallback()
                }
                guard let count : Int = self.group?.messages.count else{
                    return
                }
                if count < 10{
                    self.nextButton.isEnabled = false
                }
        })
    }
    
    @IBAction func prevButtonPress(_ sender: Any) {
        messageOffset -= 10
        nextButton.isEnabled = true
        if messageOffset <= 0{
            prevButton.isEnabled = false
        }
        group?.refreshMessages(
            offset: messageOffset,
            callback: {
                DispatchQueue.main.async {
                    self.msgCallback()
                }
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        group?.refreshMessages(
            offset: messageOffset,
            callback: {
                self.msgCallback()
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Initializes the subviews and assigns messageTableViewController's subview controller
        guard let id : String = segue.identifier else{
            return
        }
        if id == "embeddedMessageList"{
            messageTableVC = segue.destination as! EmbeddedMessageListVC
        }
        if id == "editNMSGroupSegue"{
            let vc = segue.destination as! EditNMSViewController
            vc.group = group
        }
    }
    
    @IBAction func unwindToNMSGroup(segue : UIStoryboardSegue){
    
    }
    @IBAction func unwindWithDeleteToNMSGroup(segue: UIStoryboardSegue){
        group?.refreshMessages(
            offset: messageOffset,
            callback: {
                self.msgCallback()
        })
        
    }
    func msgCallback(){
        // Pushes the [Message]? object to the message view
        //performSegue(withIdentifier: "embeddedMessageList", sender: nil) // Crashes the program
        guard let vc : EmbeddedMessageListVC = messageTableVC else{
            return
        }
        vc.group = group
        vc.refresh()
        
    }
    
    func errorCallback(){
        let alert : UIAlertController = UIAlertController(
            title: "Fatal Error!",
            message: "An error has occurred with loading the OpenNMS group. You will return to the NMS list shortly.",
            preferredStyle: .alert
        )
        let ack : UIAlertAction = UIAlertAction(
            title: "Acknowledged",
            style: .default,
            handler: { info in
                
            }
        )
    }

}
