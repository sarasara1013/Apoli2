//
//  TopViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/06.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    var userData: UserManager = UserManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushSend() {
        if (PFUser.currentUser() == nil) {
            self.performSegueWithIdentifier("toLogin", sender: nil)
        }else {
            self.performSegueWithIdentifier("toSend", sender: nil)
        }
    }
    
    @IBAction func pushCheck() {
        if (PFUser.currentUser() == nil) {
            self.performSegueWithIdentifier("toLogin", sender: nil)
        }else {
            self.performSegueWithIdentifier("toCheck", sender: nil)
        }
    }
    
    @IBAction func pushFriend() {
        if (PFUser.currentUser() == nil) {
            self.performSegueWithIdentifier("toLogin", sender: nil)
        }else {
            self.performSegueWithIdentifier("toFriend", sender: nil)
        }
    }
    
    @IBAction func signIn() {
        if (PFUser.currentUser() == nil) {
            self.performSegueWithIdentifier("toLogin", sender: nil)
        }else {
            let alert = UIAlertView()
            let message = String(format:"%@でログインしています。\nログアウトしますか？", PFUser.currentUser()!.username!)
            alert.title = "アカウント設定"
            alert.message = message
            alert.delegate = self
            alert.addButtonWithTitle("ログアウト")
            alert.addButtonWithTitle("キャンセル")
            alert.show()
        }
    }

    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            self.signOut()            
        }else if buttonIndex == 1 {
            // canceled
        }
    }
    
    func signOut() {
        SVProgressHUD.showWithStatus("処理中...", maskType: SVProgressHUDMaskType.Black)
        PFUser.logOutInBackgroundWithBlock {
            error in
            
            do {
                try PFUser.currentUser()?.delete()
                SVProgressHUD.showSuccessWithStatus("ログアウトしました", maskType: SVProgressHUDMaskType.Black)
                self.dismissViewControllerAnimated(true, completion: nil)
            }catch {
                /*
                if error == 209 {
                    PFUser.currentUser()?.delete()
                    SVProgressHUD.showSuccessWithStatus("ログアウトしました", maskType: SVProgressHUDMaskType.Black)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    // TODO: enableRevocableSession
                    PFUser.enableRevocableSessionInBackgroundWithBlock { (error: NSError?) -> Void in
                        print("Session token deprecated")
                    }
                }
                 */
                SVProgressHUD.showErrorWithStatus("電波状況の良い場所でリトライして下さい")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
