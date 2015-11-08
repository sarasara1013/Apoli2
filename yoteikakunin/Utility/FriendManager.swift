//
//  FriendManager.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/18.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class FriendManager: NSObject {
    var name: String!
    var userID: String!
    var pass: String!
    var image: UIImage!
    
    override init() {
        name = ""
        userID = ""
        pass = ""
        image = nil
    }
}
