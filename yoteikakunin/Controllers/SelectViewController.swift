//
//  SelectViewController.swift
//  yoteikakunin
//
//  Created by reina on 2015/05/04.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedNumber: Int = 0
    var friendArray = [AnyObject]()
    var friendNameArray = [String]()
    var selectedFriendsName = [String]()
    
    @IBOutlet var friendsTableView: UITableView!
    @IBOutlet var selectedNumberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedNumberLabel.text = "0"
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        /*
        friendsTableView.layer.borderWidth = 1.0
        friendsTableView.layer.borderColor = UIColor.blackColor().CGColor
         */
        
        let nib  = UINib(nibName: "FriendsCell", bundle:nil)
        friendsTableView.registerNib(nib, forCellReuseIdentifier:"FriendsCell")
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FriendsCell") as? FriendsCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "FriendCell") as? FriendsCell
        }
        
        let friendInfo = friendArray[indexPath.row] as! FriendManager
        cell?.iconImage.image = friendInfo.image
        cell?.name.text = friendInfo.name
        cell?.iconImage.layer.cornerRadius = cell!.iconImage.bounds.width / 2
        cell?.iconImage.layer.masksToBounds = true
        cell?.clipsToBounds = true
        //cell?.setCell(friendArray[indexPath.row] as! FriendManager)
        return cell!
    }
    
    // MARK: TableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendsCell
        
        // Swift 1.2
        // let isContain = contains(selectedFriendsName, cell.name.text!)
        // Swift 2.0
        let isContain = selectedFriendsName.contains(cell.name.text!)
        
        if isContain == true {
            // Swift 1.2
            // let index = find(selectedFriendsName, cell.name.text!)
            // Swift 2.0
            let index = selectedFriendsName.indexOf(cell.name.text!)
            selectedFriendsName.removeAtIndex(index!)
        }else {
            selectedFriendsName.append(cell.name.text!)
        }
        
        if cell.checkMark.image == nil {
            cell.checkMark.image = UIImage(named: "selected.png")
            selectedNumber++
        }else {
            cell.checkMark.image = nil
            selectedNumber--
        }
        
        selectedNumberLabel.text = String(selectedNumber)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: AlertView Delegate
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 2 {
            if buttonIndex == 0 {
                if selectedFriendsName.count > 0 {
                    sendPush()
                    self.performSegueWithIdentifier("toResultViewController", sender: nil)
                }else {
                    let alert = UIAlertView()
                    alert.title = "友だち選択"
                    alert.message = "アポを送信する友だちを選択して下さい"
                    alert.delegate = self
                    alert.addButtonWithTitle("OK")
                    alert.tag = 3
                    alert.show()
                }
            }
        }else if alertView.tag == 3 {
            // Push OK button
        }
    }
    
    
    // MARK: Private
    // Get data from Parse
    func loadData(){
        SVProgressHUD.showWithStatus("ロード中", maskType: SVProgressHUDMaskType.Black)
        let friendsData: PFQuery = PFQuery(className: "_User")
        friendsData.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        friendsData.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) { object, error in
            if object!["following"] != nil {
                self.friendNameArray = object!["following"] as! [String]
                for following in self.friendNameArray {
                    let userData: PFQuery = PFQuery(className: "_User")
                    userData.whereKey("username", equalTo: following)
                    userData.findObjectsInBackgroundWithBlock { objects, error in
                        print(objects)
                        do {
                            for friend in objects! {
                                let friendInfo = FriendManager()
                                friendInfo.name = friend.valueForKey("username") as! String
                                try friendInfo.image = UIImage(data:(friend["imageFile"] as! PFFile).getData())
                                self.friendArray.append(friendInfo)
                            }
                        }catch {
                            print(error)
                        }
                        self.friendsTableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            }else {
                print("following is not found")
                self.friendsTableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func showErrorAlert(error: NSError) {
        var errorMessage = error.description
        
        if error.code == 209 {
            NSLog("session token == %@", PFUser.currentUser()!.sessionToken!)
            errorMessage = "セッショントークンが切れました。ログアウトします。"
            PFUser.currentUser()?.deleteInBackgroundWithBlock { succeed, error in
                SVProgressHUD.showSuccessWithStatus("ログアウトしました", maskType: SVProgressHUDMaskType.Black)
                self.dismissViewControllerAnimated(true, completion: nil)
                PFUser.enableRevocableSessionInBackgroundWithBlock { error in
                    print("Session token deprecated")
                }
            }
            
        }
        let alertController = UIAlertController(title: "通信エラー", message: errorMessage, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel) {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
        
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func plus() {
        let alert = UIAlertView()
        alert.title = "確認"
        alert.message = "送信しますか？"
        alert.delegate = self
        alert.addButtonWithTitle("送信")
        alert.addButtonWithTitle("キャンセル")
        alert.tag = 2;
        alert.show()
    }
    
    
    @IBAction func back() {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let finishVC = segue.destinationViewController as! FinishViewController
        finishVC.friendsName = selectedFriendsName
    }
    
    // MARK: Send Push
    func sendPush() {
        //PFPush.sendPushDataToChannelInBackground(, withData: , block: )
        for friend in selectedFriendsName {
            
            let push: PFPush = PFPush()
            push.setChannel(friend)
            let data :Dictionary<String, String> = ["date": "2014/12/24", "time": "10:10", "latitude": "135", "longitude": "128", "list": "", "alert": ""]
            /*
            var message = String(format: "%@さんからメッセージが届きました。", PFUser.currentUser()!.username!)
            push.setMessage(message)
             */
            push.setData(data)
            push.sendPushInBackgroundWithBlock { succeed, error in
                print(error)
            }
        }
        print("Push Notification Sent")
    }
}
