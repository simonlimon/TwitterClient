//
//  TweetViewController.swift
//  TwitterClient
//
//  Created by Simon Posada Fishman on 6/29/16.
//  Copyright © 2016 Simon Posada Fishman. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var authorPictureView: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorScreenNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweet: Tweet? {
        didSet {
            authorNameLabel.text = tweet!.author?.name
            retweeterLabel.text = tweet!.retweeter?.name ?? nil
            authorScreenNameLabel.text = tweet!.author?.screenname
            
            tweetTextLabel.text = tweet!.text
            retweetsLabel.text = String(tweet!.retweetCount)
            
            favoritesLabel.text = String(tweet!.favoriteCount)
            
            if tweet!.retweeted! {
                retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
            } else {
                retweetButton.setImage(UIImage(named: "retweet-action"), forState: .Normal)
            }
            
            if tweet!.favorited! {
                self.favoriteButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
            } else {
                self.favoriteButton.setImage(UIImage(named: "like-action"), forState: .Normal)
            }
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .ShortStyle
            formatter.doesRelativeDateFormatting = true
            
            let dateString = formatter.stringFromDate(tweet!.timestamp!)
            
            dateLabel.text = dateString
            
            authorPictureView.setImageWithURL((tweet?.author?.profilePictureUrl)!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if (!(tweet?.retweeted)!) {
            tweet?.retweet({
                self.retweetsLabel.text = String(self.tweet!.retweetCount)
                self.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
                
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        } else {
            tweet?.unretweet({
                self.retweetsLabel.text = String(self.tweet!.retweetCount)
                self.retweetButton.setImage(UIImage(named: "retweet-action"), forState: .Normal)
                
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        }
    }

    @IBAction func onFavorite(sender: AnyObject) {
        if (!(tweet?.favorited)!) {
            tweet?.favorite({
                self.favoritesLabel.text = String(self.tweet!.favoriteCount)
                self.favoriteButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
                
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        } else {
            tweet?.unfavorite({
                self.favoritesLabel.text = String(self.tweet!.favoriteCount)
                self.favoriteButton.setImage(UIImage(named: "like-action"), forState: .Normal)
                
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
