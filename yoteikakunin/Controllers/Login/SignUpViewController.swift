//
//  SignUpViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/05.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIDTextField: UITextField!
    @IBOutlet var userPassTextField: UITextField!
    
    var userImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDTextField.delegate = self
        userPassTextField.delegate = self
        userPassTextField.secureTextEntry = true
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
    
    @IBAction func openPhotoLibrary() {
        let ipc: UIImagePickerController = UIImagePickerController();
        ipc.delegate = self
        // ipc.sourceType = UIImagePickerControllerSourceType.Camera
        ipc.allowsEditing = true
        ipc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(ipc, animated:true, completion:nil)
    }
    
    // MARK: UIImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerEditedImage] != nil {
            let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
            userImageView.image = image
            UserManager.sharedInstance.image = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // Swift 1.2
    /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if info[UIImagePickerControllerEditedImage] != nil {
            let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
            userImageView.image = image
            UserManager.sharedInstance.image = image
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil);
    }
    */
    
    @IBAction func signUp() {

        self.registerUser()
    }
    
    func registerUser() {
        SVProgressHUD.showWithStatus("登録中...", maskType: SVProgressHUDMaskType.Black)
        let user = PFUser()
        user.username = userIDTextField.text
        user.password = userPassTextField.text
        user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            if error == nil {
                // let resizedImage = UserManager.sharedInstance.image.resize(CGSizeMake(120, 120))
                // var imageData: NSData = UIImageJPEGRepresentation(resizedImage, 1.0)!
                let userImageData: NSData = UIImagePNGRepresentation(UserManager.sharedInstance.image)!
                let file: PFFile = PFFile(data: userImageData)!
                user.setObject(file, forKey: "imageFile")
                user.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                    if succeeded {
                        PFPush.subscribeToChannelInBackground(PFUser.currentUser()!.username!, block: { (success, error) -> Void in
                            if success == true {
                                SVProgressHUD.showSuccessWithStatus("登録完了!")
                            }else {
                                SVProgressHUD.showErrorWithStatus("登録失敗!")
                            }
                        })
                        self.dismiss()
                    }else {
                        NSLog("error == %@", error!)
                        self.showAlert(error!)
                        SVProgressHUD.dismiss()
                    }
                }
            } else {
                self.showAlert(error!)
            }
        }
    }
    
    @IBAction func back() {
        self.dismiss()
    }
    
    func dismiss() {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAlert(error: NSError) {
        let alertController = UIAlertController(title: "Error", message: String(format: "%@ が原因で実行できませんでした", error), preferredStyle: .Alert)
        
        let reloadAction = UIAlertAction(title: "再送信", style: .Default) {
            action in
            self.signUp()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) {
            action in
            self.dismiss()
        }
        alertController.addAction(reloadAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
