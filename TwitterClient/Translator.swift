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
    
    private static let separator = "œ"
    
    private class func encode(text: [String]) -> String {
        var result = ""
        for str in text {
            result += " " + separator + " " + str
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
        
        translateTo(lingo, text: encodedString, success: { (result: String) in
            strings = decode(result)
            
            for i in 0..<tweets.count {
                tweets[i].text = strings[i + 1]
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
                let contents = dict["contents"] as! NSDictionary
                success(contents["translated"] as! String)
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
