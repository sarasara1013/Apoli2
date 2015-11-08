//
//  LoginViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/05.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var loginIDTextField: UITextField!
    @IBOutlet var loginPassTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginIDTextField.delegate = self
        loginPassTextField.delegate = self
        loginPassTextField.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        /*
        UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 150)
        }, completion: nil)
        */
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        /*
        UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 150)
            }, completion: nil)
        */
    }
    
    // MARK: Private
    @IBAction func login() {
        SVProgressHUD.showWithStatus("ログイン中...", maskType: SVProgressHUDMaskType.Black)
        PFUser.logInWithUsernameInBackground(loginIDTextField.text!, password: loginPassTextField.text!) {
            (user, error) -> Void in
            if user != nil {
                PFPush.subscribeToChannelInBackground(PFUser.currentUser()!.username!, block: { (success, error) -> Void in
                    if success == true {
                        SVProgressHUD.showSuccessWithStatus("ログイン成功!", maskType: SVProgressHUDMaskType.Black)
                    }else {
                        SVProgressHUD.showErrorWithStatus("ログイン失敗!", maskType: SVProgressHUDMaskType.Black)
                    }
                })
                self.dismissViewControllerAnimated(true, completion: nil)
            }else {
                print("not existed user")
                self.showAlert(error!)
                //self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func showAlert(error: NSError) {
        
        var message: String = error.description
        
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        
        if error.code == 101 {
            message = "ユーザーが見つかりませんでした。IDとパスワードを再確認してログインして下さい。"
        }
        
        if objc_getClass("UIAlertController") != nil {
            let alertController = UIAlertController(title: "ログインエラー", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel) {
                action in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            //UIAlertView使用
            let av = UIAlertView(title: "ログインエラー", message: message, delegate: nil, cancelButtonTitle: "OK")
            av.show()
        }
    }
    
    @IBAction func backToTop() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
