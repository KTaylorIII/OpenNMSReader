//
//  Message.swift
//  SNMP Trap Client
//
//  Created by Kent Taylor on 9/28/16.
//  Copyright © 2016 Cybernewton Systems. All rights reserved.
//

import Foundation

class Message{
    var id : Int
    var timestamp : String
    var severity : String
    var contents : String
    
    init(id: Int, time : String, severity : String, contents : String){
        self.id = id
        self.timestamp = time
        self.severity = severity
        self.contents = contents
    }
    
}
