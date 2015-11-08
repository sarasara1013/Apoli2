//
//  FinishViewController.swift
//  yoteikakunin
//
//  Created by reina on 2015/05/04.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friendsName = [String]()
    @IBOutlet var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = NSString(format:"%@ さん", friendsName[indexPath.row]) as String
        
        return cell
    }
    
    @IBAction func back() {
        //self.navigationController?.popToRootViewControllerAnimated(true);
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}