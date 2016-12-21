//
//  MessageDetailVC.swift
//  NewSNMPPoller
//
//  Created by Kent Taylor on 12/11/16.
//  Copyright © 2016 Cybernewton Systems. All rights reserved.
//

import UIKit

class MessageDetailVC: UIViewController {
    // Note: The OpenNMS API does not have dedicated API endpoints for event deletion. There can only
    // be acknowledgements from
    var group : NMSGroup? // Used for relaying credentials
    var message : Message?
    
    // OUTLETS
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var timestampField: UITextField!
    @IBOutlet weak var severityField: UITextField!
    @IBOutlet weak var contentsField: UITextView!
    

    override func viewDidLoad() {
        
        if let id : Int = message?.id{
            idField.text = "\(id)"
        }
        
        timestampField.text = message?.timestamp
        severityField.text = message?.severity
        contentsField.text = message?.contents
        
        super.viewDidLoad()
        
        let severity = message?.severity
        if severity == nil{
            severityField.backgroundColor = UIColor(
                red: 0.6,
                green: 0.8,
                blue: 0.0,
                alpha: 0.2
            )
        }
        else{
            let sev : String = severity!
            switch sev {
            case "CRITICAL":
                severityField.backgroundColor = UIColor(
                    red: 0.8,
                    green: 0,
                    blue: 0,
                    alpha: 0.8
                )
                break
            case "MAJOR":
                severityField.backgroundColor = UIColor(
                    red: 1.0,
                    green: 0.2,
                    blue: 0.0,
                    alpha: 0.8
                )
                break
            case "MINOR":
                severityField.backgroundColor = UIColor(
                    red: 1.0,
                    green: 0.6,
                    blue: 0.0,
                    alpha: 0.8
                )
                break
            case "WARNING":
                severityField.backgroundColor = UIColor(
                    red: 1.0,
                    green: 0.8,
                    blue: 0.0,
                    alpha: 0.8
                )
                break
            case "NORMAL":
                severityField.backgroundColor = UIColor( // Dark Green
                    red: 0.2,
                    green: 0.4,
                    blue: 0.0,
                    alpha: 0.8
                )
                break
            case "INDETERMINATE":
                severityField.backgroundColor = UIColor(
                    red: 0.6,
                    green: 0.8,
                    blue: 0.0,
                    alpha: 0.8
                    
                )
                break
            default:
                // Resolves the background to the default
                severityField.backgroundColor = UIColor(
                    red: 0.8,
                    green: 0.8,
                    blue: 0.8,
                    alpha: 0.8
                )
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
 

}
