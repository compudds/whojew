//
//  LayoutController.swift
//  WhoJew
//
//  Created by Eric Cook on 4/26/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse


let reuseIdentifier = "Cell"

var yesResults = [String]()

var urls = [String]()

var names = [String]()

var newRel1 = [String]()

var newRel2 = [String]()

var idArray = [String]()

var countObj = Int()


class LayoutController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBAction func backToHome(sender: AnyObject) {
        
        self.performSegueWithIdentifier("slideshowToHome", sender: self)
        
    }
    
    @IBAction func moreSlides(sender: AnyObject) {
        
        yesResults = []
        newRel1 = []
        newRel2 = []
        
        getQuizYesArray()
    }
    
    //var randNum1 = Int()
    
    let tapRec1 = UITapGestureRecognizer()
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.navigationController?.navigationBarHidden = false
        
        if yesResults == [] {
            
            getQuizYesArray()
        
        } else {
            
        }
        self.collectionView!.delegate = self
        
        self.collectionView!.dataSource = self
        
        self.view.addSubview(collectionView!)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        noInternetConnection()
        
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
        
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(LayoutController.noInternetConnection), userInfo: nil, repeats: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 250
    }
    
    func getQuizYesArray(){
        
        for(var i=0; i<500; i++){
            
            let randNum2: Int = Int(arc4random_uniform(4400))
            
            idArray = ["\(randNum2)"] + idArray
            
        }
        
        print(idArray)
        print(idArray.count)
        
        //for(var i=0; i<500; i++){
        
        if yesResults == []{
            
            let query = PFQuery(className:"Jews")
            query.whereKey("id", containedIn: idArray)
            query.limit = 500
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
            
                    NSLog("Successfully retrieved \(objects!.count).")
                    countObj = objects!.count
                    for object in objects! {
                        
                        newRel1.append(object["cat"] as! String)
                        let name = object["fullname"] as! String
                        let newYesResults = name.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let newYesResults1 = newYesResults.stringByReplacingOccurrencesOfString("\n\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        
                        yesResults.append(newYesResults1)
                        
                        
                    }
                    
                    
                    print(yesResults)
                    print(yesResults.count)
                    
                    self.getPic1()
                    
                    
                } else {
                    
                    print(error)
                    
                    
                }
                
            }
            
        } else {
            
            self.getPic1()
            
        }
            
        //}
     
    }

    func getPic1() {
    
        for(var i=0; i<countObj; i += 1){
            
            //randNum1 = Int(arc4random_uniform(300))
            
            let trimmed = yesResults[i].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            urls = ["http://whojew.bettersearchllc.com/images/thumbs/" + trimmed + ".jpg"] + urls
            
            names = [yesResults[i].stringByReplacingOccurrencesOfString("_", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)] + names
            
            let newRelReOrder = [newRel1[i]]
            
            newRel2 = newRelReOrder + newRel2
            
        }
        
        print("\(urls)")
        print("\(names)")
        print("\(names.count)")
        
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        if names == [] {
            
            
            
        } else {
            
            cell.label.text = names[indexPath.row % 1000]
            
            let urlPath = urls[indexPath.row % 1000]
            
            let imgURL: NSURL = NSURL(string: urlPath)!
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    
                    cell.img.image = UIImage(data: data!)
                    self.tapRec1.addTarget(self, action: #selector(LayoutController.tapped))
                    cell.img.addGestureRecognizer(self.tapRec1)
                    cell.img.userInteractionEnabled = true
                    
                    
                } else {
                    print(error)
                    
                }
            })
            
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.cellForItemAtIndexPath(indexPath)!
        let fullNameArr = names[indexPath.row].componentsSeparatedByString(" ")
        firstname1 = fullNameArr[0]
        lastname1 = fullNameArr[1]
        print("\(firstname1) \(lastname1)")
        rel1 = newRel2[indexPath.row] as String
        
        tapped()
        //UIView.transitionWithView(cell, duration: 0.7, options: UIViewAnimationOptions.CurveLinear, animations: animateChangeWidth, completion: nil)
    }
    
    /*override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! UICollectionReusableView
            
            headerView.backgroundColor = UIColor.blueColor();
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath) as! UICollectionReusableView
            
            footerView.backgroundColor = UIColor.greenColor();
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }*/
    
    func tapped(){
        
        print("Tapped")
        
        self.performSegueWithIdentifier("slideshowToSingle", sender: self)
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 170, height: 300)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
}