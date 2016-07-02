//
//  Translator.swift
//  TwitterClient
//
//  Created by Simon Posada Fishman on 7/1/16.
//  Copyright © 2016 Simon Posada Fishman. All rights reserved.
//

import UIKit
import Alamofire

class Translator: NSObject {
    
    private static let separator = "(œ***œ)"
    
    private class func encode(text: [String]) -> String {
        var result = text[0]
        for i in 1..<text.count {
            result += " " + separator + " " + text[i]
        }
        return result
    }
    
    private class func decode(text: String) -> [String] {
        let result = text.componentsSeparatedByString(separator)
        return result
    }
    
    
    class func translateTweetArrayTo (lingo: Lingo, tweets: [Tweet], success: () -> (), failure: (NSError) -> ()) {
        
        var strings: [String] = []
        
        for tweet in tweets {
            strings.append(tweet.text!)
        }
        
        let encodedString = encode(strings)
        print(encodedString)
        
        translateTo(lingo, text: encodedString, success: { (result: String) in
            strings = decode(result)
            
            var skipped = 0
            
            for i in 0..<(strings.count < tweets.count ? strings.count : tweets.count){
                let str: String = strings[i]
                if str != "" {
                    tweets[i - skipped].text = str.substringFromIndex(str.startIndex.advancedBy(1))
                } else {
                    skipped += 1
                }
            }
            
            success()
            
        }) { (error: NSError) in
            failure(error)
        }
    }
    
    
    class func translateTo(lingo: Lingo, text: String, success: (String) -> (), failure: (NSError) -> ()) {
        Alamofire.request(.POST, "http://api.funtranslations.com/translate/\(lingo.str).json", parameters: ["text" : text], encoding: .URL, headers: nil).responseJSON { (response) in
            //            print (response.debugDescription)
            switch response.result {
            case .Success:
                let dict = response.result.value as! NSDictionary
                if let contents = dict["contents"] as? NSDictionary {
                    success(contents["translated"] as! String)
                } else {
                    print("API limit reached")
                }
            case .Failure(let error):
                failure(error)
            }
        }
    }
    
    class func translateToYodaMashape(text: String, success: (String) -> (), failure: (NSError) -> ()) {
        
        let headers = ["X-Mashape-Key": "M48mhFDZQOmshzahJl7q0HoU9wqAp1Te5l7jsnwGSSXO29O4S2", "Accept": "text/plain"]
        
        Alamofire.request(.GET, "https://yoda.p.mashape.com/yoda", parameters: ["sentence" : text], encoding: .URL, headers: headers).responseString { (response) in
            switch response.result {
            case .Success:
                print(response.description)
                success(response.description.substringFromIndex(response.description.startIndex.advancedBy(9)))
            case .Failure(let error):
                failure(error)
            }
        }
    }
    
}

class Lingo {
    static let pirate = Lingo(str: "pirate")
    static let yoda = Lingo(str: "yoda")
    static let minion = Lingo(str: "minion")
    static let piglatin = Lingo(str: "piglatin")
    static let dothraki = Lingo(str: "dothraki")
    static let sith = Lingo(str: "sith")
    static let chef = Lingo(str: "chef")
    static let morse = Lingo(str: "morse")
    
    let str: String
    init (str: String) {
        self.str = str
    }
}
