//
//  AppoSelectViewController.swift
//  yoteikakunin
//
//  Created by reina on 2015/11/08.
//  Copyright © 2015年 srrn. All rights reserved.
//

import UIKit

class AppoSelectViewController: UIViewController {
    
    //相手のプロフィール画像、日時を表示
    
    //parseは保留どうすればいいかまっすーに聞く
    //画像名前時間をます登録してcommit

    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet var appoTableView: UITableView!
    
    
    
    @IBAction func time(sender: AnyObject) {
        
        
    }
 
    
    
    
    
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