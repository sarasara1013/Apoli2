//
//  InputViewController.swift
//  yoteikakunin
//
//  Created by reina on 2015/05/04.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, DWTagListDelegate, UITextViewDelegate {
    
    var listArray = [String]()
    var locationManager: CLLocationManager!
    
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var timeTextField: UITextField!
    @IBOutlet var placeTextField: UITextField!
    @IBOutlet var mapPinButton: UIButton!
    @IBOutlet var listView: DWTagList!
    @IBOutlet var commentTextView: UITextView!
    //@IBOutlet var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (locationManager == nil) {
            locationManager = CLLocationManager()
        }
        
        locationManager.delegate = self
        dateTextField.delegate = self
        timeTextField.delegate = self
        placeTextField.delegate = self
        listView.delegate = self
        commentTextView.delegate = self
        
        //listView.layer.borderWidth = 1.0
        //listView.layer.borderColor = UIColor.blackColor().CGColor
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.borderColor = UIColor.blackColor().CGColor
        
        placeTextField.adjustsFontSizeToFitWidth = true;
        // FIXME: Can't adjust width size
        placeTextField.minimumFontSize = 0.2
        
        listView.userInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(
            target: self, action: "tapGesture:")
        self.view.addGestureRecognizer(tapGesture)
        
        self.initializeDateTextFieldWithDatePicker()
        self.initializeTimeTextFieldWithDatePicker()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updatePlace:", name: "updatePlace", object: nil)
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
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func initializeDateTextFieldWithDatePicker() {
        let datePicker = UIDatePicker(frame: CGRectZero)
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.minuteInterval = 5
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.addTarget(self, action: Selector("dateUpdated:"), forControlEvents: UIControlEvents.ValueChanged)
        dateTextField.inputView = datePicker
    }
    
    func initializeTimeTextFieldWithDatePicker() {
        let datePicker = UIDatePicker(frame: CGRectZero)
        datePicker.datePickerMode = UIDatePickerMode.Time
        datePicker.minuteInterval = 5
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.addTarget(self, action: Selector("timeUpdated:"), forControlEvents: UIControlEvents.ValueChanged)
        timeTextField.inputView = datePicker
    }
    
    func dateUpdated(datePicker: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        dateTextField.text = formatter.stringFromDate(datePicker.date)
    }
    
    func timeUpdated(datePicker: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH時mm分"
        timeTextField.text = formatter.stringFromDate(datePicker.date)
    }
    
    // MARK: TagList
    @IBAction func addTag() {
        if UIResponder.getCurrentFirstResponder() != nil {
            UIResponder.getCurrentFirstResponder()?.resignFirstResponder()
        }else {
            let alert = UIAlertView()
            alert.title = "もちものを追加"
            //alert.message = ""
            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
            alert.delegate = self
            alert.addButtonWithTitle("キャンセル")
            alert.addButtonWithTitle("追加")
            alert.tag = 1
            alert.show()
        }
    }

    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 1 {
            if buttonIndex == 0 {
            }else if buttonIndex == 1 {
                if alertView.textFieldAtIndex(0)!.text!.characters.count > 0 {
                    listArray.append(alertView.textFieldAtIndex(0)!.text!)
                    listView.setTags(listArray)
                }
            }
        }else if alertView.tag == 2 {
            if buttonIndex == 0 {
            }else if buttonIndex == 1 {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK: TagListDelegate
    func selectedTag(tagName: String!, tagIndex: Int) {
        NSLog("tagName %@", tagName)
        NSLog("tagIndex %d", tagIndex)
    }
    
    // MARK: TextView Delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        // Swift 2.0
        UIView.animateWithDuration(0.2, animations: {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 150)
        })
    
        // Swift 1.2
        /*
        UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 150)
            }, completion: nil)
         */
    }

    func textViewDidEndEditing(textView: UITextView) {
        // Swift 2.0
        UIView.animateWithDuration(0.2, animations: {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 150)
        })
        // Swift 1.2
        /*
        UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 150)
            }, completion: nil)
         */
    }
    
    // MARK: Private
    @IBAction func back() {
        if dateTextField.text != "" || timeTextField.text != "" || placeTextField.text != "" || commentTextView.text != "" {
            let alert = UIAlertView()
            alert.title = "トップに戻る"
            alert.message = "入力内容を破棄してトップに戻ります。\nよろしいですか？"
            alert.alertViewStyle = UIAlertViewStyle.Default
            alert.delegate = self
            alert.addButtonWithTitle("キャンセル")
            alert.addButtonWithTitle("内容を破棄して戻る")
            alert.tag = 2
            alert.show()
        }else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func getCurrentPrace() {
        SVProgressHUD.showWithStatus("現在地の取得中...", maskType: SVProgressHUDMaskType.Black)
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocationWithDesiredAccuracy(INTULocationAccuracy.City,
            timeout: 10.0,
            block: { (currentLocation:CLLocation!, achievedAccuracy:INTULocationAccuracy, status:INTULocationStatus) -> Void in
                GeoUtility().reverseGeocoding(currentLocation.coordinate)
                switch (status) {
                case .Success:
                    
                    break
                case .TimedOut:
                    self.showAlert()
                default:
                    break
                }
                SVProgressHUD.dismiss()
        })
    }
    
    func updatePlace(notification: NSNotificationCenter) {
        self.placeTextField.text = notification.valueForKey("object") as? String
        self.placeTextField.setNeedsDisplay()
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "タイムアウト", message: "通信がタイムアウトしました。電波状況等を再確認してリトライして下さい。", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel) {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Close Keyboards when tap outside itselfs
    func tapGesture(sender: UITapGestureRecognizer){
        for view in self.view.subviews {
            if view is UITextField {
                let textField = view as! UITextField
                if(textField.isFirstResponder()) {
                    textField.resignFirstResponder()
                    return
                }
            }else if view is UITextView {
                let textView = view as! UITextView
                if(textView.isFirstResponder()) {
                    textView.resignFirstResponder()
                    return
                }
            }
        }
    }
    
    // TODO: GO NEXT
    @IBAction func goNext() {
        if dateTextField.text == "" || timeTextField.text == "" || placeTextField.text == "" || commentTextView.text == "" {
            let alert = UIAlertView()
            alert.title = "入力エラー"
            alert.message = "入力してください"
            alert.alertViewStyle = UIAlertViewStyle.Default
            alert.delegate = self
            alert.addButtonWithTitle("OK")
            alert.tag = 3
            alert.show()
        }else {
            self.performSegueWithIdentifier("toSelect", sender: nil)
        }
    }
}
