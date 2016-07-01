//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Simon Posada Fishman on 6/30/16.
//  Copyright © 2016 Simon Posada Fishman. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var tweetTextField: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.tweet(tweetTextField.text, success: { 
            self.tweetTextField.text = ""
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error: NSError) in
                print(error.localizedDescription)
        }
    }

    @IBAction func onCancel(sender: AnyObject) {
        self.tweetTextField.text = ""
        self.dismissViewControllerAnimated(true, completion: nil)
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
