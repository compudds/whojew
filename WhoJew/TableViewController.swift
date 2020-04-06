//
//  TableViewController.swift
//  WhoJew
//
//  Created by Eric Cook on 3/18/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse

var results1 = String()
var cat1 = String()
var rel1 = String()
var firstname1 = String()
var lastname1 = String()

class TableViewController: UITableViewController {

    var imageFiles = UIImage()
    
    @IBAction func backToHome(_ sender: AnyObject) {
       
         self.performSegue(withIdentifier: "resultsToHome", sender: self)
        
    }
    @IBOutlet var img: UIImageView!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 

        let url1 = "http://whojew.bettersearchllc.com/images/thumbs/" + "\(firstname[indexPath.row])" + "_" + "\(lastname[indexPath.row])" + ".jpg"
        
        let imgURL: URL = URL(string: url1)!
        
        let request: URLRequest = URLRequest(url: imgURL)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(data, response, error) -> Void in
            if error == nil {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 75, width: 75, height: 0))
                let imgGet = UIImage(data: response!)
                let fixedImage = UIImage(named: "female-placeholder.png")
                
                let size = CGSize(width: 125, height: 150)
                
                //self.view.addSubview(imageView)
                
                if imgGet != nil {
                    //self.img.image = UIImage(data: data!)
                    imageView.image = imgGet
                    cell.imageView?.image = self.imageResize(imageView.image!,sizeChange: size) //UIImage(data: data!)
                } else {
                    //self.img.image = UIImage(named: "female-placeholder.png")
                    imageView.image = fixedImage
                    cell.imageView?.image = self.imageResize(imageView.image!,sizeChange: size)  //UIImage(named: "female-placeholder.png")
                }
                
            } else {
                print(error!)
            }
        }) //as! (URLResponse?, Data?, Error?) -> Void)

        
        cell.textLabel?.text = " \(results[indexPath.row])"
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        results1 = results[indexPath.row]
        cat1 = cat[indexPath.row]
        rel1 = rel[indexPath.row]
        firstname1 = firstname[indexPath.row]
        lastname1 = lastname[indexPath.row]
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.performSegue(withIdentifier: "listToSingle", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        self.navigationController?.isNavigationBarHidden = true
        
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        noInternetConnection()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @objc func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
        } else {
            
            print("Internet connection FAILED")
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Sorry, no internet connection found.", message: "WhoJew? requires an internet connection.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again?", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                self.dismissAlert()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }
    
    func dismissAlert(){
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(TableViewController.noInternetConnection), userInfo: nil, repeats: false)
        
    }
    
    func imageResize (_ image:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
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
