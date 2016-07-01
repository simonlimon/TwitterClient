//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Simon Posada Fishman on 6/28/16.
//  Copyright © 2016 Simon Posada Fishman. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            userLabel.text = tweet!.author?.name
            retweeterLabel.text = tweet!.retweeter?.name ?? nil
            
            tweetLabel.text = tweet!.text
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
            
            profilePictureView.setImageWithURL((tweet?.author?.profilePictureUrl)!)
        }
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
    
    @IBAction func onYoda(sender: AnyObject) {
//        tweet?.translateToPirate({
//            self.tweetLabel.text = self.tweet?.text
//        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
