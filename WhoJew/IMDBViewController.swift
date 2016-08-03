//
//  IMDBViewController.swift
//  WhoJew
//
//  Created by Eric Cook on 4/19/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse
import iAd

class ImdbViewController: UIViewController, ADBannerViewDelegate {
    
    @IBAction func imdbToHome(sender: AnyObject) {
        
        self.performSegueWithIdentifier("imdbToHome", sender: self)
    }
    
    @IBAction func backToSlideshow(sender: AnyObject) {
        
        self.performSegueWithIdentifier("imdbToSlideshow", sender: self)
        
    }
    
    @IBOutlet var containerView: UIWebView!
    
    @IBOutlet var adBannerView: ADBannerView?
    
    @IBAction func imdbToSearch(sender: AnyObject) {
        
        self.performSegueWithIdentifier("imdbToList", sender: self)
        
        
    }
    
    @IBAction func imdbToWiki(sender: AnyObject) {
        
        self.performSegueWithIdentifier("imdbToWiki", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.navigationController?.navigationBarHidden = true
        
        if self.adBannerView != nil {
            
            //self.adBannerView!.delegate = self
            self.canDisplayBannerAds = true
            print("iAd is showing")
            
        } else {
            
            //self.adBannerView!.delegate = self
            self.adBannerView!.hidden = true
            print("iAd not showing")
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        noInternetConnection()
        
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            let url = NSURL(string:"http://m.imdb.com/find?ref_=nv_sr_fn&q=" + firstname1 + "+" + lastname1 + "&s=all")
            let req = NSURLRequest(URL:url!)
            containerView!.loadRequest(req)
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            
            
        } else {
            
            print("Internet connection FAILED")
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Sorry, no internet connection found.", message: "WhoJew? requires an internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again?", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.dismissAlert()
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        
    }
    
    func dismissAlert(){
        
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(ImdbViewController.noInternetConnection), userInfo: nil, repeats: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
