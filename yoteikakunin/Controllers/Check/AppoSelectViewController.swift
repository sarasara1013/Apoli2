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
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    //通知がきたら一番上にくる
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    


}
