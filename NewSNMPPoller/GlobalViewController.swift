//
//  GlobalViewController.swift
//  NewSNMPPoller
//
//  Created by Kent Taylor on 12/7/16.
//  Copyright © 2016 Cybernewton Systems. All rights reserved.
//

import UIKit

class GlobalViewController: UIViewController {
    var timer : Timer?
    
    //var nmsGroups : NMSGroupList = NMSGroupList()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Quick hack to fix floating count issue
        if (nmsGroupList.groups?.count == nil || (nmsGroupList.groups?.count)! <= 0){
            nmsGroupList.groups = []
        }
        
        super.viewDidLoad()
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

}
