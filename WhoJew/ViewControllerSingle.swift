//
//  SingleViewController.swift
//  WhoJew
//
//  Created by Eric Cook on 8/16/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//


import UIKit
import Parse
import iAd


class ViewControllerSingle: UIViewController, ADBannerViewDelegate {
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var catrel: UILabel!
    
    @IBOutlet var adBannerView: ADBannerView?
    
    @IBAction func wiki(sender: AnyObject) {
        
        self.performSegueWithIdentifier("singleToWiki", sender: self)
        
    }
    
    
    /*@IBAction func singleToSlideshow(sender: AnyObject) {
        
        self.performSegueWithIdentifier("backToSlideshow", sender: self)
        
    }*/
    
    
    @IBAction func imdbPressed(sender: AnyObject) {
        
        
        self.performSegueWithIdentifier("singleToImdb", sender: self)
        
        
    }
    @IBAction func backToHome(sender: AnyObject) {
        
        self.performSegueWithIdentifier("singleToHome", sender: self)
        
    }
    
    
    @IBAction func backToList(sender: AnyObject) {
        
        self.performSegueWithIdentifier("backToList", sender: self)
        
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
        
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
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
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let url1 = "http://whojew.bettersearchllc.com/images/thumbs/" + firstname1 + "_" + lastname1 + ".jpg"
            
            name.text = firstname1 + " " + lastname1 //results1
            
            catrel.text = rel1 as String
            
            let imgURL: NSURL = NSURL(string: url1)!
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    let imgGet = UIImage(data: data!)
                    if imgGet != nil {
                        self.img.image = UIImage(data: data!)
                    } else {
                        self.img.image = UIImage(named: "female-placeholder.png")
                    }
                    
                } else {
                    print(error)
                }
            })
            
            
            
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
        
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("noInternetConnection"), userInfo: nil, repeats: false)
        
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
