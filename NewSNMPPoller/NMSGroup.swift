//
//  ManagementGroup.swift
//  SNMP Trap Client
//
//  Created by Kent Taylor on 9/28/16.
//  Copyright © 2016 Cybernewton Systems. All rights reserved.
//

import Foundation
import Alamofire

class NMSGroup{
    var name : String
    var http_protocol : String
    var nmsdomain : String
    var nmsport : Int
    //var desc : String
    var status : String
    
    var user: String = ""
    var password: String = ""
    
    //var hosts : [Host] = [] // OpenNMS Nodes
    var messages : [Message] = [] // OpenNMS Messages
    
    init(name : String, http_protocol : String, nmsdomain : String, nmsport : Int, status : String){
        self.name = name
        //self.desc = desc
        self.status = status
        self.http_protocol = http_protocol
        self.nmsport = nmsport
        self.nmsdomain = nmsdomain
    }
    func testCredentials(username : String, password : String, success : (()->Void)?, failure : (()->Void)?){
        let basic_val = "\(self.user):\(self.password)".data(using: .utf8)!.base64EncodedString()
        let headers = [
            "Accept" : "application/json",
            "Authorization" : basic_val
            
        ]
        Alamofire.request(
            "\(self.http_protocol)\(self.nmsdomain):\(self.nmsport)/opennms/rest/events",
            headers : headers
            ).responseJSON(completionHandler: { response in
                if response.response?.statusCode == 200{
                    guard let function = success else{
                        return
                    }
                    function()
                }
                else{
                    guard let function = failure else{
                        return
                    }
                    function()
                }
            })
        
    }
    /*func pollNodes(offset : Int, callback: (()->Void)?){
        hosts = []
        // Resetting the hosts to an empty array, to prevent duplicates
        let basic_val = "\(self.user):\(self.password)".data(using: .utf8)!.base64EncodedString()
        let headers = [
            "Accept" : "application/json",
            "Authorization" : basic_val
        
        ]
        Alamofire.request(
            "\(http_protocol)\(nmsdomain):\(nmsport)/opennms/rest/nodes?offset",
            headers: headers
        ).responseJSON(
            completionHandler: {
                response in
                if response.result.isSuccess{
                    let json = JSON(response.result.value)
                    guard let count : Int = json["totalCount"].int else{
                        return // Data corruption likely.
                    }
                    if count > 10{
                        for index : Int in 0..<10{
                            guard let id : Int = json["node"][index]["id"].int else{
                                continue // Malformed JSON likely
                            }
                            
                            guard let label : String = json["node"][index]["label"].string else{
                                continue
                            }
                            // Due to OpenNMS's scan scheduling behavior, assetRecord subobjects are optls.
                            let room : String? = json["node"][index]["assetRecords"]["room"].string
                            let floor : String? = json["node"][index]["assetRecords"]["floor"].string
                            let building : String? = json["node"][index]["assetRecords"]["building"].string
                            let city : String? = json["node"][index]["assetRecords"]["city"].string
                            
                            let host : Host = Host(
                                id: id,
                                room: room,
                                floor: floor,
                                building: building,
                                city: city,
                                label: label
                            )
                            self.hosts.append(host)
                        }
                    }
                    
                }
                guard let function : (()->Void) = callback else{
                    return // No callback function to call
                }
                function() // Called after updating the list
            
            }
        )
    }
    */
    func refreshMessages(offset : Int, callback : (() -> Void)?){
        // Purging old messages is bliss.
        messages = []
        let basic_val = "\(self.user):\(self.password)"
        let headers = [
            "Accept" : "application/json",
            "Authorization" : "Basic \(basic_val.data(using: String.Encoding.utf8)!.base64EncodedString())"
        
        ]
        Alamofire.request("\(http_protocol)\(nmsdomain):\(nmsport)/opennms/rest/events?offset=\(offset)&orderBy=id&order=desc", headers: headers).responseJSON{ response in
            if response.result.isSuccess{
                let test = JSON(response.result.value)
                let _totalCount = test["totalCount"]
                guard let totalCount = _totalCount.int else{
                    return // Invalid/ Malformed JSON formation.
                }
                // Iterating through the JSONified list of messages
                if (totalCount - offset)>10{
                    for index in 0..<10{
                        
                        // If malformed JSON is detected, move on to next index
                        guard let id : Int = test["event"][index]["id"].int else{
                            continue
                        }
                        guard let severity : String = test["event"][index]["severity"].string else{
                            continue
                        }
                        guard let contents : String = test["event"][index]["logMessage"].string else{
                            continue
                        }
                        guard let ts : Int = test["event"][index]["time"].int else{
                            continue
                        }
                        // Converting UNIX time to a human-readable format
                        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(ts))
                        let msg : Message = Message(
                            id: id,
                            time: date.description,
                            severity: severity,
                            contents: contents
                        )
                        self.messages.append(msg)
                    }
                }
                
                // Callback upon message JSON parsing
                
                guard let function : (()->Void) = callback else{
                    return
                }
                function()
            }
            //let json = JSON(response)
            //print(json["events"])
            
            
            
        }
    }
    func acknowledgeMessage(message : Message, successCallback : (()->Void)?, failureCallback : (()->Void)?){
        let basic_val = "\(self.user):\(self.password)"
        let headers = [
            "Accept" : "application/json",
            "Authorization" : "Basic \(basic_val.data(using: String.Encoding.utf8)!.base64EncodedString())"
            
        ]
        Alamofire.request("\(http_protocol)\(nmsdomain):\(nmsport)/opennms/rest/events/\(message.id)?ack=true",
            headers : headers
            ).responseString(completionHandler: {response in
                
                if response.response?.statusCode == 200 { // SUCCESS
                    guard let success : (()->Void) = successCallback else{
                        return
                    }
                    success()
                    print(response.result.value)
                }
                else{
                    guard let failure : (()->Void) = failureCallback else{
                        return
                    }
                    failure()
                }
            })
    }
}
