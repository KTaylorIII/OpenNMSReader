//
//  NMSGroupList.swift
//  NewSNMPPoller
//
//  Created by Kent Taylor on 12/7/16.
//  Copyright © 2016 Cybernewton Systems. All rights reserved.
//

import Foundation
//import SQLite
import Alamofire

class NMSGroupList{
    var groups : [NMSGroup]?
    
    init(){
        groups = []
        //initTables()
        //loadData()
    }
    /*func initTables(){
        do{
            let db = try Connection("NewSNMPPoller.sqlite3")
            
            
            let NMSGroups = Table("NMS_Groups")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let domain = Expression<String>("domain")
            let port = Expression<Int64>("port")
            let user = Expression<String>("user")
            let password = Expression<String>("password")
            let status = Expression<String>("status")
            
            try db.run(NMSGroups.create(ifNotExists: true){table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(domain)
                table.column(port)
                table.column(user)
                table.column(password)
                table.column(status)
            })
            
        }
        catch{
            
        }
    }
    
    func loadData(){
        
        /*

         Loads data from the mobile device-bound SQLite3 database into
         memory. Used to extract NMS Group information, including credentials,
         and populate the table.
 
         */
        
        do{
            let db = try Connection("NewSNMPPoller.sqlite3")
            db.busyTimeout = 5 // seconds
            
            let NMSGroups = try Table("NMS_Groups")
            let name = Expression<String>("name")
            let prot = Expression<String>("http_protocol")
            let domain = Expression<String>("domain")
            let port = Expression<Int64>("port")
            let user = Expression<String>("user")
            let password = Expression<String>("password")
            let status = Expression<String>("status")
            
            for group in try db.prepare(NMSGroups){
                let nmsgroup = NMSGroup(name: group[name], http_protocol: group[prot], nmsdomain: group[domain], nmsport: Int(group[port]), status: group[status])
                nmsgroup.user = group[user]
                nmsgroup.password = group[password]
                groups!.append(
                    nmsgroup
                )
            }
            
        }
        catch{ // Database connection is contentious or otherwise unavailable
            groups = nil
            return
        }
        
        
    }
    */
    func refreshGroups(callback : (()->Void)?){
        /*
         Iterates through each NMSGroup, calling a function that tests basic connectivity to the server
         Should a connection fail, the status shall be updated accordingly
         */
        guard let count = groups?.count else{
            return
        }
        guard count > 0 else{
            return
        }
        // "Count" is defined and greater than zero
        _refreshGroups(index: 0, callback : callback)
        
    }
    private func _refreshGroups(index : Int, callback : (()->Void)?){
        guard let count : Int = groups?.count else{
            return
        }
        guard let group : NMSGroup = groups?[index] else{
            return
        }
        
        let auth = "\(group.user):\(group.password)".data(using: .utf8)?.base64EncodedString()
        let headers = [
            "Accept" : "application/json",
            "Authorization" : "Basic \(auth)"
        
        ]
        Alamofire.request( // Events result is irrelevant. Only the HTTP status matters.
            "\(group.http_protocol)\(group.nmsdomain):\(group.nmsport)/opennms/rest/events",
            headers : headers
            ).responseJSON(completionHandler: { response in
                
                if (response.response?.statusCode == 200){
                    group.status = "ACTIVE"
                    // The group is active and good to go!
                }
                else{
                    group.status = "INACTIVE" // Invalid credentials & settings, a poor connection, or
                    // something of anoter nature may be impeding network access
                }
                // Callback handler
                
                if (callback != nil){
                    callback!()
                }
                
                // Proceed to next group in the list
                let next = index+1
                if next < count{
                    self._refreshGroups(index: next, callback : callback)
                }
            }
        )
        
    }
}
let nmsGroupList = NMSGroupList()
