//
//  EmbeddedMessageListVC.swift
//  NewSNMPPoller
//
//  Created by Kent Taylor on 12/11/16.
//  Copyright © 2016 Cybernewton Systems. All rights reserved.
//

import UIKit

class EmbeddedMessageListVC: UITableViewController {
    
    var group : NMSGroup?
    
    func refresh(){
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard (group?.messages.count) != nil else{
            return 0
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let count = group?.messages.count else{
            return 0
        }
        return count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let grp : NMSGroup = group else{
            return // An error occurred. Terminating peacefully.
        }
        let msg : Message = grp.messages[indexPath.row]
        performSegue(withIdentifier: "messageDetailSegue", sender: msg)
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = UITableViewCellStyle.value1
        let cell = UITableViewCell(
            style: style,
            reuseIdentifier: nil
        )
        if group?.messages[indexPath.row].severity == nil{
            cell.backgroundColor = UIColor( // Light green (INDETERMINATE)
                red: 0.6,
                green: 0.6,
                blue: 0.0,
                alpha: 0.8
            )
        }
        else{
            let severity : String = (group?.messages[indexPath.row].severity)!
            switch severity {
            case "CRITICAL":
                cell.backgroundColor = UIColor(
                    red: 0.8,
                    green: 0,
                    blue: 0,
                    alpha: 0.8
                )
                break
            case "MAJOR":
                cell.backgroundColor = UIColor(
                    red: 1.0,
                    green: 0.2,
                    blue: 0.0,
                    alpha: 0.8
                )
                break
            case "MINOR":
                cell.backgroundColor = UIColor(
                    red: 1.0,
                    green: 0.6,
                    blue: 0.0,
                    alpha: 0.8
                )
                break
            case "WARNING":
                cell.backgroundColor = UIColor(
                    red: 1.0,
                    green: 0.8,
                    blue: 0.0,
                    alpha: 0.8
                )
                break
            case "NORMAL":
                cell.backgroundColor = UIColor( // Dark Green
                    red: 0.2,
                    green: 0.4,
                    blue: 0.0,
                    alpha: 0.8
                )
                break
            case "INDETERMINATE":
                cell.backgroundColor = UIColor(
                    red: 0.6,
                    green: 0.8,
                    blue: 0.0,
                    alpha: 0.8
                
                )
                break
            default:
                // Resolves the background to the default
                cell.backgroundColor = UIColor(
                    red: 0.8,
                    green: 0.8,
                    blue: 0.8,
                    alpha: 0.8
                )
            }
        }
        cell.accessoryType = UITableViewCellAccessoryType.detailButton

        // Cell data
        
        cell.textLabel?.textColor = UIColor.white
        let id : Int = (group?.messages[indexPath.row].id)!
        let severity : String = (group?.messages[indexPath.row].severity)!
        let contents : String = (group?.messages[indexPath.row].contents)!
        cell.textLabel?.text = "\(id) - \(severity): \(contents)" // Placeholder

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let id : String = segue.identifier else{
            return
        }
        if id == "messageDetailSegue"{
            let dest : MessageDetailVC = segue.destination as! MessageDetailVC
            guard let message : Message = sender as! Message else{
                return
            }
            dest.message = message
            guard let forc_group : NMSGroup = group else{
                return
            }
            dest.group = forc_group
            
        }
        
    }
    

}
