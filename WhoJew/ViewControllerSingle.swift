//
//  SingleViewController.swift
//  WhoJew
//
//  Created by Eric Cook on 8/16/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//


import UIKit
import Parse



class ViewControllerSingle: UIViewController {
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var catrel: UILabel!
    
    @IBAction func wiki(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "singleToWiki", sender: self)
        
    }
    
    
    /*@IBAction func singleToSlideshow(sender: AnyObject) {
        
        self.performSegueWithIdentifier("backToSlideshow", sender: self)
        
    }*/
    
    
    @IBAction func imdbPressed(_ sender: AnyObject) {
        
        
        self.performSegue(withIdentifier: "singleToImdb", sender: self)
        
        
    }
    @IBAction func backToHome(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "singleToHome", sender: self)
        
    }
    
    
    @IBAction func backToList(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "backToList", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        self.navigationController?.isNavigationBarHidden = true
        
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        noInternetConnection()
    }
    
    @objc func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            let url1 = "http://whojew.bettersearchllc.com/images/thumbs/" + firstname1 + "_" + lastname1 + ".jpg"
            
            name.text = firstname1 + " " + lastname1 //results1
            
            catrel.text = rel1 as String
            
            let imgURL: URL = URL(string: url1)!
            
            let request: URLRequest = URLRequest(url: imgURL)
            
           NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(data, response, error) -> Void in
                if error == nil {
                    let imgGet = UIImage(data: response!)
                    if imgGet != nil {
                        self.img.image = UIImage(data: response!)
                    } else {
                        self.img.image = UIImage(named: "female-placeholder.png")
                    }
                    
                } else {
                    print(error!)
                }
            } )//as! (URLResponse?, Data?, Error?) -> Void)
            
            
            
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
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ViewControllerSingle.noInternetConnection), userInfo: nil, repeats: false)
        
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
