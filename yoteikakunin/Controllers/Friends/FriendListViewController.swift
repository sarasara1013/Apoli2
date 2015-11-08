//
//  FriendListViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/18.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var friendListTableView: UITableView!
    var friendArray = [AnyObject]()
    var friendNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendListTableView.dataSource = self
        friendListTableView.delegate = self
        
        /*
        friendListTableView.layer.borderWidth = 1.0
        friendListTableView.layer.borderColor = UIColor.blackColor().CGColor
        */
        
        let nib  = UINib(nibName: "FriendsCell", bundle:nil)
        friendListTableView.registerNib(nib, forCellReuseIdentifier:"FriendsCell")
        
        // self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Get data from Parse
    func loadData(){
        SVProgressHUD.showWithStatus("ロード中", maskType: SVProgressHUDMaskType.Black)
        
        let myFriendsQuery: PFQuery = PFQuery(className: "_User")
        myFriendsQuery.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { object, error in
            if object!.valueForKey("following") != nil {
                self.friendNameArray = object!["following"] as! [String]
                for following in self.friendNameArray {
                    let userData: PFQuery = PFQuery(className: "_User")
                    userData.whereKey("username", equalTo: following)
                    userData.findObjectsInBackgroundWithBlock { objects, error in
                        do {
                            for friend in objects! {
                                let friendInfo = FriendManager()
                                friendInfo.name = friend["username"] as! String
                                try friendInfo.image = UIImage(data:(friend["imageFile"] as! PFFile).getData())
                                self.friendArray.append(friendInfo)
                            }
                        }catch {
                            print(error)
                        }
                        self.friendListTableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            }
        })
    }
    
    func showErrorAlert(error: NSError) {
        var errorMessage = error.description
        
        if error.code == 209 {
            NSLog("session token == %@", PFUser.currentUser()!.sessionToken!)
            errorMessage = "セッショントークンが切れました。ログアウトします。"
            do {
                try PFUser.currentUser()?.delete()
                PFUser.enableRevocableSessionInBackgroundWithBlock { (error: NSError?) -> Void in
                    print("Session token deprecated")
                }
            }catch {
                print(error)
            }
            
            SVProgressHUD.showSuccessWithStatus("ログアウトしました", maskType: SVProgressHUDMaskType.Black)
            self.dismissViewControllerAnimated(true, completion: nil)
            
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
    
    // MARK: TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendsCell") as? FriendsCell
        /*
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "FriendCell") as? FriendsCell
        }
         */
        
        let friendInfo = friendArray[indexPath.row] as! FriendManager
        cell?.iconImage.image = friendInfo.image
        cell?.name.text = friendInfo.name
        cell?.iconImage.layer.cornerRadius = cell!.iconImage.bounds.width / 2
        cell?.iconImage.layer.masksToBounds = true
        cell?.clipsToBounds = true

        // TEST: cell?.textLabel!.text = friendNameArray[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func back() {
        //self.navigationController?.popToRootViewControllerAnimated(true);
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    // TODO: フォロー解除
}
