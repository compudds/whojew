
//  QuizViewController.swift
//  WhoJew
//
//  Created by Eric Cook on 4/19/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse
//import iAd

class QuizViewController: UIViewController {
    
    @IBOutlet var pic1: UIImageView!
    
    @IBOutlet var pic2: UIImageView!
    
    @IBOutlet var label1: UILabel!
    
    @IBOutlet var label2: UILabel!
    
    @IBAction func quizToHome(sender: AnyObject) {
        
        self.performSegueWithIdentifier("quizToHome", sender: self)
        
    }
    
    let tapRec1 = UITapGestureRecognizer()
    let tapRec2 = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        noInternetConnection()
        
        play()
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
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
        
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("noInternetConnection"), userInfo: nil, repeats: false)
        
    }
    
    
    func play(){
        
        getQuizYesArray()
        
        playNo()
        
    }
    
    func playNo(){
        
        getQuizNoArray()
    }
    
    var yesResults = [String]()
    var noResults = [String]()
    var newYesResults = [String]()
    var newNoResults = [String]()
    
    func getQuizYesArray(){
        
        if yesResults == []{
            let query = PFQuery(className:"Quiz")
            query.whereKey("jew", equalTo: "y")
            query.limit = 196 //no=152
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    
                    NSLog("Successfully retrieved \(objects.count).")
                    
                    for object in objects {
                        
                        let name = object["fullname"] as! String
                        let newYesResults = name.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let newYesResults1 = newYesResults.stringByReplacingOccurrencesOfString("\n\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        
                        self.yesResults.append(newYesResults1)
                        
                    }
                    
                    
                    print(self.yesResults)
                    print(self.yesResults.count)
                    self.getPic1()
                    
                } else {
                    
                    print(error)
                    
                }
                
            }
            
        } else {
            
            self.getPic1()
        }
        
    }
    
    func getQuizNoArray(){
        
        if noResults == []{
            let query = PFQuery(className:"Quiz")
            query.whereKey("jew", equalTo: "n")
            query.limit = 152 //no=152
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    
                    NSLog("Successfully retrieved \(objects.count).")
                    
                    for object in objects {
                        
                        let name = object["fullname"] as! String
                        let newNoResults = name.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let newNoResults1 = newNoResults.stringByReplacingOccurrencesOfString("\n\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        self.noResults.append(newNoResults1)
                        
                    }
                    
                    print(self.noResults)
                    print(self.noResults.count)
                    
                    self.getPic2()
                    
                } else {
                    
                    print(error)
                    
                }
                
            }
            
        } else {
            
            self.getPic2()
        }
        
    }
    
    var randNum1 = Int()
    
    func getPic1() {
        
        randNum1 = Int(arc4random_uniform(196))
        
        print(randNum1)
        
        let trimmed = yesResults[randNum1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let url = "http://whojew.bettersearchllc.com/images/thumbs/" + trimmed + ".jpg"
        
        let newLabel = yesResults[randNum1].stringByReplacingOccurrencesOfString("_", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let imgURL: NSURL = NSURL(string: url)!
        
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
            if error == nil {
                
                let imgGet = UIImage(data: data!)
                
                if self.randNum1 < 88 {
                    
                    if imgGet != nil {
                        
                        self.pic1.image = UIImage(data: data!)
                        self.label1.text = newLabel
                        self.tapRec1.addTarget(self, action: "tappedYes")
                        self.pic1.addGestureRecognizer(self.tapRec1)
                        self.pic1.userInteractionEnabled = true
                        
                    } else {
                        
                        self.pic1.image = UIImage(named: "female-placeholder.png")
                        self.label1.text = newLabel
                        self.tapRec1.addTarget(self, action: "tappedYes")
                        self.pic1.addGestureRecognizer(self.tapRec1)
                        self.pic1.userInteractionEnabled = true
                        
                    }
                    
                } else {
                    
                    if imgGet != nil {
                        
                        self.pic2.image = UIImage(data: data!)
                        self.label2.text = newLabel
                        self.tapRec1.addTarget(self, action: "tappedYes")
                        self.pic2.addGestureRecognizer(self.tapRec1)
                        self.pic2.userInteractionEnabled = true
                        
                        
                    } else {
                        
                        self.pic2.image = UIImage(named: "female-placeholder.png")
                        self.label2.text = newLabel
                        self.tapRec1.addTarget(self, action: "tappedYes")
                        self.pic2.addGestureRecognizer(self.tapRec1)
                        self.pic2.userInteractionEnabled = true
                        
                    }
                    
                }
                
            } else {
                print(error)
            }
        })
        
        
    }
    
    func getPic2() {
        
        let randNum = Int(arc4random_uniform(152))
        
        print(randNum)
        
        let trimmed = noResults[randNum].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let url = "http://whojew.bettersearchllc.com/images/thumbs/nonjews/" + trimmed + ".jpeg"
        
        let newLabel = noResults[randNum].stringByReplacingOccurrencesOfString("_", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let imgURL: NSURL = NSURL(string: url)!
        
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
            if error == nil {
                
                let imgGet = UIImage(data: data!)
                
                if self.randNum1 < 88 {
                    
                    if imgGet != nil {
                        
                        self.pic2.image = UIImage(data: data!)
                        self.label2.text = newLabel
                        self.tapRec2.addTarget(self, action: "tappedNo")
                        self.pic2.addGestureRecognizer(self.tapRec2)
                        self.pic2.userInteractionEnabled = true
                        
                        
                        
                    } else {
                        
                        self.pic2.image = UIImage(named: "female-placeholder.png")
                        self.label2.text = newLabel
                        self.tapRec2.addTarget(self, action: "tappedNo")
                        self.pic2.addGestureRecognizer(self.tapRec2)
                        self.pic2.userInteractionEnabled = true
                        
                    }
                    
                } else {
                    
                    if imgGet != nil {
                        
                        self.pic1.image = UIImage(data: data!)
                        self.label1.text = newLabel
                        self.tapRec2.addTarget(self, action: "tappedNo")
                        self.pic1.addGestureRecognizer(self.tapRec2)
                        self.pic1.userInteractionEnabled = true
                        
                        
                    } else {
                        
                        self.pic1.image = UIImage(named: "female-placeholder.png")
                        self.label1.text = newLabel
                        self.tapRec2.addTarget(self, action: "tappedNo")
                        self.pic1.addGestureRecognizer(self.tapRec2)
                        self.pic1.userInteractionEnabled = true
                        
                    }
                    
                }
                
            } else {
                print(error)
            }
        })
        
        
    }
    
    func tappedYes(){
        
        print("Yes Tapped")
        
        let alert = UIAlertController(title: "Awesome!", message: "You got it right.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            self.play()
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    func tappedNo(){
        
        print("No Tapped")
        
        let alert = UIAlertController(title: "Sorry!", message: "That's incorrect.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            self.play()
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
