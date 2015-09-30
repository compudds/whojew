//
//  ViewController.swift
//  WhoJew
//
//  Created by Eric Cook on 3/18/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse
import iAd

var results = [String]()
var cat = [String]()
var rel = [String]()
var firstname = [String]()
var lastname = [String]()

var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

class ViewController: UIViewController, ADBannerViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet var scroll: UIScrollView!
    
    @IBAction func homeToSlideshow(sender: AnyObject) {
        
        self.performSegueWithIdentifier("homeToNav", sender: self)
        
    }
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var adBannerView: ADBannerView? //connect in IB connection inspector with your ADBannerView
    
    @IBAction func quizBtnPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("homeToQuiz", sender: self)
        
    }
    @IBAction func toAbout(sender: AnyObject) {
        
        self.performSegueWithIdentifier("homeToAbout", sender: self)
    }
    @IBAction func btnPressed(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        let string = textField.text!.capitalizedString
        //string.capitalizedString
        let trimmed = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        print("Trimmed: \(trimmed)")
        
        if textField.text == "" || textField.text == nil {
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Search can not be blank.", message: "Please enter a valid search.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "New Search", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                self.textField.text = ""
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        } else {
            
        let query = PFQuery(className:"Jews")
        query.whereKey("fullname", hasPrefix: trimmed)
        query.limit = 500
        //query.whereKey("firstname", hasPrefix: trimmed)
        //query.whereKey("lastname", hasPrefix: trimmed)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                    NSLog("Successfully retrieved \(objects.count).")
                
                    for object in objects {
                        //NSLog("%@", object.objectId)
                        results.append(object["fullname"] as! String)
                        cat.append(object["cat"] as! String)
                        rel.append(object["rel"] as! String)
                        firstname.append(object["firstname"] as! String)
                        lastname.append(object["lastname"] as! String)
                        print(results)
                        //println(cat)
                        //println(rel)
                        print(results.count)
                        
                        }
                
                self.findName()
            
            } else {
                
                print(error)
                
            }
            }
        }
     
    }
    
    func findName(){
        
        let string = textField.text!.capitalizedString
        //string.capitalizedString
        let trimmed = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if results.count > 0 {
            
            let search = PFObject(className:"InDatabase")
            search["search"] = trimmed
            search["jewish"] = true
            search.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    // The object has been saved.
                    print("The search has been saved to \"InDatabase\".")
                } else {
                    // There was a problem, check error.description
                    print(error)
                }
            }

            
            self.performSegueWithIdentifier("results", sender: self)
            
        } else {
            
            results = []
            cat = []
            rel = []
            firstname = []
            lastname = []
            
            
            if trimmed.rangeOfString(" ") != nil {
            
            let fullNameArr = trimmed.componentsSeparatedByString(" ")
            
            if fullNameArr == [] {
                
                } else {
                    let firstName: String = fullNameArr[0]
                    firstname1 = firstName
                    let lastName: String = fullNameArr[1]
                    lastname1 = lastName
                }
            } else {
                
                firstname1 = trimmed
                
            }
            
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let search = PFObject(className:"NotInDatabase")
            search["search"] = trimmed
            search["jewish"] = false
            search.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    // The object has been saved.
                    print("The search has been saved to \"NotInDatabase\".")
                } else {
                    // There was a problem, check error.description
                    print(error)
                }
            }

            
            let alert = UIAlertController(title: "Sorry, no results found.", message: "\(trimmed) is not Jewish or partially Jewish.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "New Search", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                self.textField.text = ""
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Wikipedia", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                self.performSegueWithIdentifier("homeToWiki", sender: self)
                
            }))
            
            alert.addAction(UIAlertAction(title: "IMDB", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                self.performSegueWithIdentifier("homeToImdb", sender: self)
                
            }))

            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        

        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
    
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scroll.contentSize.height = 700
        scroll.contentSize.width = 267
        
        results = []
        cat = []
        rel = []
        firstname = []
        lastname = []
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        self.navigationController?.navigationBarHidden = true
        
        if self.adBannerView != nil {
            
            self.canDisplayBannerAds = true
            print("iAd is showing")
            
        } else {
            
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
            
            //yesPic()
            
           
        } else {
            
            print("Internet connection FAILED")
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Sorry, no internet connection found.", message: "WhoJew? requires an internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again?", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                //self.noInternetConnection()
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


}

