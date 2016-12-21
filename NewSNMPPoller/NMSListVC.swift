//
//  NMSListVC.swift
//  NewSNMPPoller
//
//  Created by Kent Taylor on 12/7/16.
//  Copyright © 2016 Cybernewton Systems. All rights reserved.
//

import UIKit

class NMSListVC: UITableViewController {
    
    // Note: All OpenNMS groups are stored in a static list declared right after NMSGroupList's definition
    // hence the absence of its declaration here
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nmsGroupList.refreshGroups(
            callback: {
                self.tableView.reloadData() // Reloads data each time the group list is analyzed
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count : Int = nmsGroupList.groups?.count else{
            return 0 // No entries in table
        }
        // #warning Incomplete implementation, return the number of rows
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let groups = nmsGroupList.groups else{
            // Return a default, blank cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "nil_cell", for: indexPath)
            return cell
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "\(groups[indexPath.row].name)_cell")
        cell.textLabel?.text = groups[indexPath.row].name
        cell.imageView?.image = UIImage(
            named: "\(groups[indexPath.row].status.lowercased()).png")
        // Configure the cell...

        return cell
    }
    
    // Upon selection, performs the segue to the NMSGroupVC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(
            withIdentifier: "NMSGroupSegue",
            sender: tableView.cellForRow(
                at: indexPath
            )
        )
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

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "NMSGroupSegue"{
            let dest = segue.destination as! NMSViewController
            let source = sender as! UITableViewCell
            let index = self.tableView.indexPath(for: source)?.row
            dest.group = nmsGroupList.groups?[index!]
        }
        
    }
    
    // Listens for connections from other VCs
    @IBAction func unwindToNMSList(segue : UIStoryboardSegue){
        self.tableView.reloadData()
    }

}
