//
//  ViewController.swift
//  WhoJew
//
//  Created by Eric Cook on 3/18/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
///

import UIKit
import Parse


var results = [String]()
var cat = [String]()
var rel = [String]()
var firstname = [String]()
var lastname = [String]()

var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scroll: UIScrollView!
    
    @IBAction func homeToSlideshow(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "homeToNav", sender: self)
        
    }
    
    @IBOutlet var textField: UITextField!
    
    
    @IBAction func quizBtnPressed(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "homeToQuiz", sender: self)
        
    }
    @IBAction func toAbout(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "homeToAbout", sender: self)
    }
    @IBAction func btnPressed(_ sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        let string = textField.text!.capitalized
        //string.capitalizedString
        let trimmed = string.trimmingCharacters(in: CharacterSet.whitespaces)
        print("Trimmed: \(trimmed)")
        
        if textField.text == "" || textField.text == nil {
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Search can not be blank.", message: "Please enter a valid search.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "New Search", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
                self.textField.text = ""
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            
        let query = PFQuery(className:"Jews")
        query.whereKey("fullname", hasPrefix: trimmed)
        query.limit = 500
        //query.whereKey("firstname", hasPrefix: trimmed)
        //query.whereKey("lastname", hasPrefix: trimmed)
        query.findObjectsInBackground {
            (objects, error) in
            if error == nil {
                
                    NSLog("Successfully retrieved \(objects!.count).")
                
                    for object in objects! {
                        
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
                
                print(error!)
               
            }
            }
        }
     
    }
    
    func findName(){
        
        let string = textField.text!.capitalized
        //string.capitalizedString
        let trimmed = string.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if results.count > 0 {
            
            let search = PFObject(className:"InDatabase")
            search["search"] = trimmed
            search["jewish"] = true
            search.saveInBackground(block: {
                (success, error) in
                if (success) {
                    // The object has been saved.
                    print("The search has been saved to \"InDatabase\".")
                } else {
                    // There was a problem, check error.description
                    print(error!)
                }
            })

            
            self.performSegue(withIdentifier: "results", sender: self)
            
        } else {
            
            results = []
            cat = []
            rel = []
            firstname = []
            lastname = []
            
            
            if trimmed.range(of: " ") != nil {
            
            let fullNameArr = trimmed.components(separatedBy: " ")
            
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
            UIApplication.shared.endIgnoringInteractionEvents()
            
            let search = PFObject(className:"NotInDatabase")
            search["search"] = trimmed
            search["jewish"] = false
            search.saveInBackground(block: {
                (success, error) in
                if (success) {
                    // The object has been saved.
                    print("The search has been saved to \"NotInDatabase\".")
                } else {
                    // There was a problem, check error.description
                    print(error!)
                }
            })

            
            let alert = UIAlertController(title: "Sorry, no results found.", message: "\(trimmed) is not Jewish or partially Jewish.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "New Search", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
                self.textField.text = ""
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Wikipedia", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
                self.performSegue(withIdentifier: "homeToWiki", sender: self)
                
            }))
            
            alert.addAction(UIAlertAction(title: "IMDB", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
                self.performSegue(withIdentifier: "homeToImdb", sender: self)
                
            }))

            self.present(alert, animated: true, completion: nil)
            
        }
        
        

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
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
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        self.navigationController?.isNavigationBarHidden = true
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        noInternetConnection()
        
        
    }
    
    @objc func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            //yesPic()
            
           
        } else {
            
            print("Internet connection FAILED")
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Sorry, no internet connection found.", message: "WhoJew? requires an internet connection.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again?", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                //self.noInternetConnection()
                self.dismissAlert()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }
    
    func dismissAlert(){
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ViewController.noInternetConnection), userInfo: nil, repeats: false)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

