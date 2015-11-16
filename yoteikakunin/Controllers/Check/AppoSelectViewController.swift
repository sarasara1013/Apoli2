//
//  AppoSelectViewController.swift
//  yoteikakunin
//
//  Created by reina on 2015/11/08.
//  Copyright © 2015年 srrn. All rights reserved.
//

import UIKit

class AppoSelectViewController: UIViewController {
    
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet var appoTableView: UITableView!
    
    

    //通知がきたら一番上にくる
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    func setCell(friend: FriendManager) {
        self.name.text = friend.name
    
    }}