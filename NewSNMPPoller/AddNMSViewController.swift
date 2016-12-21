//
//  AddNMSViewController.swift
//  NewSNMPPoller
//
//  Created by Kent Taylor on 12/8/16.
//  Copyright © 2016 Cybernewton Systems. All rights reserved.
//

import UIKit
import Alamofire

class AddNMSViewController: UIViewController, UITextFieldDelegate {
    
    // OUTLETS - Proceed further to reach the VC core.
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var submitNMSButton: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var domainField: UITextField!
    @IBOutlet weak var portField: UITextField!
    @IBOutlet weak var protocolSwitch: UISegmentedControl!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // BUTTON FUNCTIONS
    
    @IBAction func nameFieldEndEdit(_ sender: Any) {
        setSubmitEnabled(value: validateForm())
    }
    @IBAction func domainFieldEndEdit(_ sender: Any) {
        setSubmitEnabled(value: validateForm())
    }
    
    @IBAction func portFieldEndEdit(_ sender: Any) {
        guard Int(portField.text!) != nil && Int(portField.text!)! > 0 else{
            portField.text = "8443"
            let alert = UIAlertController(
                title: "Invalid port number!",
                message: "Port numbers must be positive integers! The default OpenNMS port of 8433 has been chosen for the port value. Change it to something else if you desire.",
                preferredStyle: .alert
            )
            let acknowledged = UIAlertAction(
                title: "Understood",
                style: .cancel,
                handler: nil
            )
            alert.addAction(acknowledged)
            setSubmitEnabled(value: validateForm())
            present(alert, animated: true, completion: nil)
            return
        }
        setSubmitEnabled(value: validateForm())
        
    }
    
    @IBAction func usernameFieldEndEdit(_ sender: Any) {
        setSubmitEnabled(value: validateForm())
    }
    
    @IBAction func passwordFieldEndEdit(_ sender: Any) {
        setSubmitEnabled(value: validateForm())
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setSubmitEnabled(value: validateForm())
        if (textField == nameField){
            textField.resignFirstResponder()
            domainField.becomeFirstResponder()
            return false
        }
        else if (textField == domainField){
            textField.resignFirstResponder()
            portField.becomeFirstResponder()
            return false
        }
        else if (textField == portField){
            textField.resignFirstResponder()
            usernameField.becomeFirstResponder()
            return false
        }
        else if (textField == passwordField){
            textField.resignFirstResponder()
            
            return false
        }
        return true
        
    }
    
    // SEGMENT SWITCH FUNCTIONS
    
    @IBAction func protocolSwitched(_ sender: Any) {
        if protocolSwitch.selectedSegmentIndex == 1{
            let alert = UIAlertController(
                title: "Alert!",
                message: "You have chosen HTTP as the preferred protocol for this NMS group. HTTP is considered insecure and can be sniffed by deep packet sniffers. Are you sure you wish to use HTTP?",
                preferredStyle: .alert)
            let yes = UIAlertAction(
                title: "Yes",
                style: .default,
                handler: { alertAction in
                    return
                    
                    
                }
            )
            let no = UIAlertAction(
                title: "Revert Protocol",
                style: .cancel,
                handler: { alertAction in
                    self.protocolSwitch.selectedSegmentIndex = 0
                    
                }
            )
            alert.addAction(yes)
            alert.addAction(no)
            present(alert, animated: true, completion: nil)
            
            
            
        }
    }
    
    
    // VIEW CONTROLLER CORE FUNCTIONALITY
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        domainField.delegate = self
        portField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectToGroup(_ sender: Any) {
        let name : String = nameField.text!
        let domain : String = domainField.text!
        let port : Int = Int(portField.text!)!
        let http_prot : String = protocolSwitch.titleForSegment(at: protocolSwitch.selectedSegmentIndex)!
        let username : String = usernameField.text!
        let password : String = passwordField.text!
        
        
        
        // Connects to an NMS group. If successful, group is added to the NMS list
        // Otherwise, user has option to save, retry, or otherwise return to the NMS menu.
        
        // Concatenating the protocol with domain name.
        
        // Initializing the potential group to be added.
        let group = NMSGroup(
            name: name,
            http_protocol: "\(http_prot)",
            nmsdomain: "\(domain)",
            nmsport: port,
            status: "UNKNOWN"
        )
        group.user = username
        group.password = password
        
        let http_auth_header : String = (("\(group.user):\(group.password)").data(using: String.Encoding.utf8)?.base64EncodedString())!
        print(http_auth_header)
        
        let headers : HTTPHeaders = [
            "Accept" : "application/json",
            "Authorization" : "Basic \(http_auth_header)"
        ]
        // Due to Alamofire's asynchronous mode of operation, there is some implementation of object
        // manipulation. I apologize for this inconvenience.
        
        Alamofire.request(
            "\(http_prot)\(domain):\(port)/opennms/rest/nodes",
            headers : headers
        ).responseJSON{ response in
            guard let code = response.response?.statusCode else{
                
                /*
                 If there is no response, the user has the option to store the NMS Group, edit the form,
                 or cancel and return to the NMS list
                 */
                group.status = "INACTIVE"
                let no_connect_alert = UIAlertController(
                    title: "Connection Timed Out",
                    message: "An error has occurred with the connection to host \(domain). It is possible that you have entered an invalid domain. Would you like to edit or otherwise store the NMS group anyway?",
                    preferredStyle: UIAlertControllerStyle.alert
                )
                let edit = UIAlertAction(
                    title: "Edit Settings",
                    style: UIAlertActionStyle.default,
                    handler: { action in
                        return
                    }
                )
                /*let submit = UIAlertAction(
                    title: "Submit Group",
                    style: UIAlertActionStyle.default,
                    handler: { action in
                        nmsGroupList.groups?.append(group)
                        self.performSegue(withIdentifier: "backFromAddNMSGroup", sender: nil)
                        
                    }
                
                )*/
                let cancel = UIAlertAction(
                    title: "Return to NMS List",
                    style: UIAlertActionStyle.cancel,
                    handler: { action in
                        self.performSegue(withIdentifier: "backFromAddNMSGroup", sender: nil)
                    }
                
                )
                no_connect_alert.addAction(edit)
                //no_connect_alert.addAction(submit)
                no_connect_alert.addAction(cancel)
                self.present(no_connect_alert, animated: true, completion: nil)
                
                return
            }
            
            /*
             At this point, it is assumed the response generated an HTTP code and should be processed
             */
            if code == 200{
                // The test connection was successful
                let alert = UIAlertController(
                    title: "Authorization Successful",
                    message: "You have successfully connected to the OpenNMS server. Would you like to save this profile for further access?",
                    preferredStyle: .alert
                )
                let ack = UIAlertAction(
                    title: "Yes. Return to menu",
                    style: .default,
                    handler: { action in
                        nmsGroupList.groups?.append(group)
                        self.performSegue(withIdentifier: "backFromAddNMSGroup", sender: nil)
                    }
                )
                let edit = UIAlertAction(
                    title: "No. Edit OpenNMS Profile",
                    style: .default,
                    handler: { action in
                        return
                    }
                )
                let leave = UIAlertAction(
                    title: "No. Return to menu",
                    style: .default,
                    handler: { action in
                        self.performSegue(withIdentifier: "backFromAddNMSGroup", sender: nil)
                    }
                )
                alert.addAction(ack)
                alert.addAction(edit)
                alert.addAction(leave)
                self.present(alert, animated: true, completion: nil)
    
            }
            else{
                let alert = UIAlertController(
                    title: "Unable to Authenticate",
                    message: "The server is down, nonexistent, or else your credentials might be invalid. Would you like to save or edit the profile to try again?",
                    preferredStyle: .alert
                )
                let edit = UIAlertAction(
                    title: "Edit Profile",
                    style: .default,
                    handler: { action in
                        return
                                        }
                )
                let save = UIAlertAction(
                    title: "Save and exit to menu",
                    style: .default,
                    handler: { action in
                        nmsGroupList.groups?.append(group)
                        self.performSegue(withIdentifier: "backFromAddNMSGroup", sender: nil)
                }
                )
                let leave = UIAlertAction(
                    title: "No. Return to menu",
                    style: .default,
                    handler: { action in
                        self.performSegue(withIdentifier: "backFromAddNMSGroup", sender: nil)
                    }
                )
                alert.addAction(edit)
                alert.addAction(save)
                alert.addAction(leave)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // VIEW STATE MUTATORS & COMPARISON OPS
    
    func setSubmitEnabled(value : Bool){
        submitNMSButton.isEnabled = value
    }
    
    func validateForm() -> Bool{
        var result = validateField(field: nameField) && validateField(field: domainField)
        result = result && validateField(field: usernameField)
        result = result && validateField(field: passwordField)
        result = result && validPort()
        
        if (result){
            return true
        }
        else{
            return true
        }
    }
    func validPort() -> Bool{
        guard (portField.text) != nil else{
            return false
        }
        guard Int(portField.text!) != nil else{
            return false
        }
        guard Int(portField.text!)! < 65536 && Int(portField.text!)! >= 0 else{
            return false
        }
        return true
    }
    func validateField(field : UITextField) -> Bool{
        guard (field.text) != nil else{
            return false
        }
        guard !((field.text?.isEmpty)!) else{
            
            return false
        }
        return true
    }
    

}
