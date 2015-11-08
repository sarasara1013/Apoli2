//
//  ListTableView.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/17.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class ListTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var listArray: Array<Any>!
    var inputField: UITextField!
    
    init(frame: CGRect) {
        super.init(frame: frame, style: .Plain)
        self.delegate = self
        self.dataSource = self
        self.separatorInset = UIEdgeInsetsZero
        
        listArray = []
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.delegate = self
        self.dataSource = self
        self.separatorInset = UIEdgeInsetsZero
        
        listArray = []
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return listArray.count
        if listArray.count < 1 {
            listArray.append("")
        }
        return listArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath) as UITableViewCell!
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ListCell")
        }

        self.inputField = cell!.viewWithTag(1) as! UITextField
        self.inputField.delegate = self;
        //self.inputField.placeholder = "もちものを入力"
        self.inputField.text = String(format: "%@", listArray[indexPath.row] as! String)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
