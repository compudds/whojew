//
//  IMDBViewController.swift
//  WhoJew
//
//  Created by Eric Cook on 4/19/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse
import WebKit


class ImdbViewController: UIViewController {
    
    @IBAction func imdbToHome(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "imdbToHome", sender: self)
    }
    
    @IBAction func backToSlideshow(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "imdbToSlideshow", sender: self)
        
    }
    
    @IBOutlet var webView: WKWebView!
    
    @IBAction func imdbToSearch(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "imdbToList", sender: self)
        
        
    }
    
    @IBAction func imdbToWiki(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "imdbToWiki", sender: self)
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
        
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        noInternetConnection()
        
    }
    
    @objc func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            let url = URL(string:"http://m.imdb.com/find?ref_=nv_sr_fn&q=" + firstname1 + "+" + lastname1 + "&s=all")
            let req = URLRequest(url:url!)
            webView!.load(req)
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            
            
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
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ImdbViewController.noInternetConnection), userInfo: nil, repeats: false)
        
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
