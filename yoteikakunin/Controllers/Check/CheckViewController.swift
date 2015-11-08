//
//  CheckViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/07.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit
import MapKit

class CheckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, DWTagListDelegate {
    
    var readArray = [String]()
    var listArray = [String]()
    
    @IBOutlet var table: UITableView!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var listView: DWTagList!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var timeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.delegate = self
        listView.userInteractionEnabled = true
        table.dataSource = self
        // table.delegate = self
        
        listView.setTags(listArray)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setMap()
    }
    
    private func setMap() {
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.68154,139.752498)
        
        mapView.setCenterCoordinate(location,animated:true)
        
        // 縮尺を設定
        var region:MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        mapView.setRegion(region,animated:true)
        
        //mapView.mapType = MKMapType.Satellite
        //mapView.mapType = MKMapType.Hybrid
        mapView.mapType = MKMapType.Standard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = readArray[indexPath.row]
        return cell
    }
    
    // MARK: TagListDelegate
    func selectedTag(tagName: String!, tagIndex: Int) {
        NSLog("tagName %@", tagName)
        NSLog("tagIndex %d", tagIndex)
    }
    
    
    // MARK: Private
    @IBAction func backToTop() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
