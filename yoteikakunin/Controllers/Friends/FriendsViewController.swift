//
//  FriendsViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/07.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToTop() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
