//
//  GeoUtility.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/13.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class GeoUtility: NSObject {
    
    var place: String!
    
    class var sharedInstance: GeoUtility {
        struct Static {
            static let instance: GeoUtility = GeoUtility()
        }
        return Static.instance
    }
    
    override init() {
        place = ""
    }
    
    func reverseGeocoding(coordinate: CLLocationCoordinate2D) -> Void {
        // Use Optional for checking nil in if-sentence
        var placeString: String?
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            if (error == nil && placemarks!.count > 0) {
                let placemark = placemarks![0] 
                //println("Country = \(placemark.country)")
                //println("Postal Code = \(placemark.postalCode)")
                //println("Sub Administrative Area = \(placemark.subAdministrativeArea)")
                
                placeString = placemark.administrativeArea! + placemark.locality! + placemark.subLocality! + placemark.thoroughfare!
                
            }else if (error == nil && placemarks!.count == 0) {
                print("No results were returned.")
                
                placeString = error!.localizedDescription
            }else if (error != nil) {
                print("An error occured = \(error!.localizedDescription)")
                placeString = error!.localizedDescription
            }
            
            if let str = placeString {
                let notification : NSNotification = NSNotification(name: "updatePlace", object: str, userInfo: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            }
        })
        
        // Swift 1.2
        /*
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil && placemarks.count > 0) {
                let placemark = placemarks[0] as! CLPlacemark
                //println("Country = \(placemark.country)")
                //println("Postal Code = \(placemark.postalCode)")
                //println("Sub Administrative Area = \(placemark.subAdministrativeArea)")
                
                placeString = placemark.administrativeArea + placemark.locality + placemark.subLocality + placemark.thoroughfare
                
            }else if (error == nil && placemarks.count == 0) {
                println("No results were returned.")
                
                placeString = error.localizedDescription
            }else if (error != nil) {
                println("An error occured = \(error.localizedDescription)")
                placeString = error.localizedDescription
            }
            
            if let str = placeString {
                var notification : NSNotification = NSNotification(name: "updatePlace", object: placeString, userInfo: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            }
        })
        */
        self.place = placeString
    }
}
