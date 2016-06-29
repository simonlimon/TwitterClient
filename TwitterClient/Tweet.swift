//
//  Tweet.swift
//  TwitterClient
//
//  Created by Simon Posada Fishman on 6/27/16.
//  Copyright © 2016 Simon Posada Fishman. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: NSDate?
    var retweeted: Bool?
    var favorited: Bool?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    
    var retweeter: User?
    var author: User?
    var id: Int?
    
    private var client = TwitterClient.sharedInstance

    init(dictionary: NSDictionary) {
        retweeted = dictionary["retweeted"] as? Bool
        
        text = (dictionary["retweeted_status"]?["text"] ?? dictionary["text"]) as? String
        
        
        favorited = (dictionary["retweeted_status"]?["favorited"] ?? dictionary["favorited"]) as? Bool
        retweetCount = (dictionary["retweeted_status"]?["retweet_count"] ?? dictionary["retweet_count"]) as? Int ?? 0
        
        favoriteCount = (dictionary["retweeted_status"]?["favorite_count"] ?? dictionary["favorite_count"]) as? Int ?? 0
        
        if let authorDict = dictionary["retweeted_status"]?["user"] as? NSDictionary {
            self.author = User(dictionary: authorDict)
            self.retweeter =  User(dictionary: dictionary["user"] as! NSDictionary)
        } else {
            self.author =  User(dictionary: dictionary["user"] as! NSDictionary)
            self.retweeter = nil
        }
        
        id = dictionary["id"] as? Int
        
        if let timestampString = (dictionary["retweeted_status"]?["created_at"] ?? dictionary["created_at"]) as? String {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    func retweet(success: () -> (), failure: (NSError) -> ()) {
        let url = "1.1/statuses/retweet/\(id!).json"
        client.POST(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, result: AnyObject?) in
            self.retweetCount += 1
            self.retweeted = true
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func unretweet(success: () -> (), failure: (NSError) -> ()) {
        let url = "1.1/statuses/unretweet/\(id!).json"
        client.POST(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, result: AnyObject?) in
            self.retweetCount -= 1
            self.retweeted = false
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func favorite(success: () -> (), failure: (NSError) -> ()) {
        let url = "1.1/favorites/create.json?id=\(id!)"
        client.POST(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, result: AnyObject?) in
            self.favoriteCount += 1
            self.favorited = true
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func unfavorite(success: () -> (), failure: (NSError) -> ()) {
        let url = "1.1/favorites/destroy.json?id=\(id!)"
        client.POST(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, result: AnyObject?) in
            self.favoriteCount -= 1
            self.favorited = false
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    class func tweetsFromArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }

}
