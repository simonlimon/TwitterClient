//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Simon Posada Fishman on 6/29/16.
//  Copyright © 2016 Simon Posada Fishman. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet] = []

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var webpageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundPictureView: UIImageView!
    @IBOutlet weak var profilePictureView: UIImageView!
    
    var user: User? {
        didSet {
            followersLabel.text = String(user!.followersCount)
            followingLabel.text = String(user!.followingCount)
            webpageLabel.text = user!.url?.absoluteString
            locationLabel.text = user!.location
            statusLabel.text = user!.info
            screenNameLabel.text = user!.screenname
            nameLabel.text = user!.name
            
            backgroundPictureView.setImageWithURL(user!.backgroundImageUrl!)
            profilePictureView.setImageWithURL(user!.profilePictureUrl!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = User.currentUser
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.fetchTweets()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        fetchTweets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTweets () {
        print("fetching")
        TwitterClient.sharedInstance.userTimeline((user?.screenname)!, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()
        }) { (error: NSError) in
            print("error: " + error.localizedDescription)
            self.tableView.dg_stopLoading()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    deinit {
        tableView.dg_removePullToRefresh()
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

