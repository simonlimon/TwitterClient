//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Simon Posada Fishman on 6/27/16.
//  Copyright © 2016 Simon Posada Fishman. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import KCFloatingActionButton
import SVPullToRefresh

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]! = []
    let client = TwitterClient.sharedInstance
    
    
    let buttonLingos: [Lingo] = [Lingo.pirate, Lingo.yoda, Lingo.sith, Lingo.minion, Lingo.morse, Lingo.chef, Lingo.dothraki]
    
    let buttonIcons: [UIImage] = [UIImage(named: "pirate")!, UIImage(named: "yoda")!, UIImage(named: "sith")!, UIImage(named: "minion")!, UIImage(named: "morse")!, UIImage(named: "chef")!, UIImage(named: "dothraki")! ]
    

    
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
            self!.tweets = []
            self!.fetchTweets()
        }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

        fetchTweets()
        
        let frame = CGRectMake(self.view.frame.width - 60, self.view.frame.height - 110, 50, 50)
        
        let fab = KCFloatingActionButton(frame: frame)
        
        for i in 0..<buttonLingos.count {
            fab.addItem(buttonLingos[i].str.capitalizedString, icon: buttonIcons[i], handler: { (item: KCFloatingActionButtonItem) in
                Translator.translateTweetArrayTo(self.buttonLingos[i], tweets: self.tweets, success: {
                    print("translated to: " + self.buttonLingos[i].str)
                    self.tableView.reloadData()
                }, failure: { (error: NSError) in
                    print(error)
                })
                fab.close()
            })
        }
        
        self.view.addSubview(fab)
        
        tableView.addInfiniteScrollingWithActionHandler { 
            self.fetchTweets()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func fetchTweets () {
        client.homeTimeline(tweets!.last?.id, success: { (tweets: [Tweet]) in
            var copy = tweets
            copy.removeFirst()
            self.tweets.appendContentsOf(copy)
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()
            self.tableView.infiniteScrollingView.stopAnimating()
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
    
    @IBAction func onCompose(sender: AnyObject) {
        self.performSegueWithIdentifier("ComposeSegue", sender: self)
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
        } else if let vc = segue.destinationViewController as? ProfileViewController {
            let cell = sender!.superview!!.superview as! TweetCell
            vc.loadView()
            vc.user = cell.tweet?.author
            vc.viewDidLoad()
        }
    }

}

extension UIScrollView {
    func dg_stopScrollingAnimation() {}
}