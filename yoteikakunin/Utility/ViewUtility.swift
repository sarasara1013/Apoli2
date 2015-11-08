//
//  ViewUtility.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/18.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class ViewUtility: NSObject {
    class func findFirstResponder(view: UIView) -> UIView {
        let returnView = UIView()
        if view.isFirstResponder() {
            return view
        }
        for subView in view.subviews {
            if subView.isFirstResponder() == false {
                return subView 
            }
            let responder = self.findFirstResponder(subView)
            if let responder = responder as UIView? {
                return responder
            }
        }
        return returnView
    }
}

// UIResponder Extention
extension UIResponder {
    
    //Class var not supported in 1.0
    private struct CurrentFirstResponder {
        static var currentFirstResponder: UIResponder?
    }
    private class var currentFirstResponder: UIResponder? {
        get { return CurrentFirstResponder.currentFirstResponder }
        set(newValue) { CurrentFirstResponder.currentFirstResponder = newValue }
    }
    
    class func getCurrentFirstResponder() -> UIResponder? {
        currentFirstResponder = nil
        UIApplication.sharedApplication().sendAction("findFirstResponder", to: nil, from: nil, forEvent: nil)
        return currentFirstResponder
    }
    
    func findFirstResponder() {
        UIResponder.currentFirstResponder = self
    }
}

extension UIImage {
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        UIGraphicsBeginImageContext(resizedSize)
        drawInRect(CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    /*
    func resize(ratio: CGFloat) -> UIImage {
        let resizedSize = CGSize(width: Int(self.size.width * ratio), height: Int(self.size.height * ratio))
        UIGraphicsBeginImageContext(resizedSize)
        drawInRect(CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    */
}
