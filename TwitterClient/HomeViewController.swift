//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Simon Posada Fishman on 6/27/16.
//  Copyright © 2016 Simon Posada Fishman. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    let client = TwitterClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func fetchTweets () {
        client.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()
        }) { (error: NSError) in
            print("error: " + error.localizedDescription)
            self.tableView.dg_stopLoading()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        User.currentUser = nil
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? TweetViewController {
            vc.loadView()
            vc.tweet = tweets[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
 

}

extension UIScrollView {
    func dg_stopScrollingAnimation() {}
}