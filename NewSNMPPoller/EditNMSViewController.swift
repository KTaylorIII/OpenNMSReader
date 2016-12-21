//
//  EditNMSViewController.swift
//  NewSNMPPoller
//
//  Created by Kent Taylor on 12/10/16.
//  Copyright © 2016 Cybernewton Systems. All rights reserved.
//

import UIKit

class EditNMSViewController: UIViewController {
    var group : NMSGroup?
    // OUTLETS
    @IBOutlet weak var labelField: UITextField!
    @IBOutlet weak var domainField: UITextField!
    @IBOutlet weak var portField: UITextField!
    
    @IBOutlet weak var protocolSwitch: UISegmentedControl!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let grp = group else{
            return
        }
        labelField.text = grp.name
        domainField.text = grp.nmsdomain
        portField.text = String(grp.nmsport)
        if (grp.http_protocol == "https://"){
            protocolSwitch.selectedSegmentIndex = 0
        }
        if (grp.http_protocol == "http://"){
            protocolSwitch.selectedSegmentIndex = 1
        }
        usernameField.text = grp.user
        passwordField.text = grp.password
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func reconnect(_ sender: Any) {
        let grp : NMSGroup = NMSGroup(
            name: labelField.text!,
            http_protocol: protocolSwitch.titleForSegment(at: protocolSwitch.selectedSegmentIndex)!,
            nmsdomain: domainField.text!,
            nmsport: Int(portField.text!)!,
            status: "UNKNOWN"
        )
        group?.testCredentials(
            username: usernameField.text!,
            password: passwordField.text!,
            success: {
                let alert = UIAlertController(
                    title: "Valid Credentials",
                    message: "You have supplied valid credentials. Would you like to save your changes?",
                    preferredStyle: UIAlertControllerStyle.alert)
                let yes = UIAlertAction(title: "Yes", style: .default, handler: { action in
                    grp.user = self.usernameField.text!
                    grp.password = self.passwordField.text!
                    self.group = grp
                    self.performSegue(withIdentifier: "unwindToNMSGroupSegue", sender: nil)
                })
        
            },
            failure: nil)
    }

}
