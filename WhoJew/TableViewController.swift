//
//  TableViewController.swift
//  WhoJew
//
//  Created by Eric Cook on 3/18/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse
import iAd

var results1 = String()
var cat1 = String()
var rel1 = String()
var firstname1 = String()
var lastname1 = String()

class TableViewController: UITableViewController, ADBannerViewDelegate {

    //var imageFiles = UIImage()
    
    @IBAction func backToHome(sender: AnyObject) {
       
         self.performSegueWithIdentifier("resultsToHome", sender: self)
        
    }
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var adBannerView: ADBannerView?
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 

        cell.textLabel?.text = "\(results[indexPath.row])"
        
        cell.textLabel?.numberOfLines = 0
        
        /*self.imageFiles[indexPath.row].getDataInBackgroundWithBlock{
        (imageData: NSData!, error: NSError!) -> Void in
        
        if error == nil {
        
        let image = UIImage(data: imageData)
        
        cell.img.image = image
        
        } else {
        
        println(error)
        
        }
        
        }
        
        cell.sizeToFit()*/

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        results1 = results[indexPath.row]
        cat1 = cat[indexPath.row]
        rel1 = rel[indexPath.row]
        firstname1 = firstname[indexPath.row]
        lastname1 = lastname[indexPath.row]
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.performSegueWithIdentifier("listToSingle", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
