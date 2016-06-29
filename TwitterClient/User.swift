//
//  User.swift
//  TwitterClient
//
//  Created by Simon Posada Fishman on 6/27/16.
//  Copyright © 2016 Simon Posada Fishman. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profilePictureUrl: NSURL?
    var tagline: String?
    
    var dictionary = NSDictionary?()
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screenname"] as? String
        
        if let urlString = (dictionary["profile_image_url_https"] as? String) {
            profilePictureUrl = NSURL(string: urlString)
        }
        
        tagline = dictionary["description"] as? String
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let data = defaults.objectForKey("currentUser") as? NSData
                
                if let data = data {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        }
        set(user) {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUser")
            } else {
                defaults.setObject(nil, forKey: "currentUser")
            }
            
            defaults.synchronize()
        }
    }
}
