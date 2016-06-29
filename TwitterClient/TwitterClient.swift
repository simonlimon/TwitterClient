//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Simon Posada Fishman on 6/27/16.
//  Copyright © 2016 Simon Posada Fishman. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "D4pEdotaRjrPWX3BPozh90ckg", consumerSecret: "L8l3WfkwLVkGLpF4WvQKG1nTTz5Tca5RNJrjvYZpwuex9oloVL")

    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterclient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) in
            self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential.init(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            print("Access token fetched")
            
            self.currentAccount({ (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
        }) { (error: NSError!) in
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(TwitterClient.userDidLogoutNotification, object: nil)
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let tweetDicts = response as! [NSDictionary]
            let tweets = Tweet.tweetsFromArray(tweetDicts)
            
            success(tweets)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let userDict = response as! NSDictionary
            let user = User(dictionary: userDict)
            success(user)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
}
