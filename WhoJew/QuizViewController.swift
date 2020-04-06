
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
    
    @IBAction func quizToHome(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "quizToHome", sender: self)
        
    }
    
    let tapRec1 = UITapGestureRecognizer()
    let tapRec2 = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        play()
    }
    
    @objc func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
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
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(QuizViewController.noInternetConnection), userInfo: nil, repeats: false)
        
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
            query.findObjectsInBackground(block: {
                (objects, error) in
                if error == nil {
                    
                    NSLog("Successfully retrieved \(objects!.count).")
                    
                    for object in objects! {
                        
                        let name = object["fullname"] as! String
                        let newYesResults = name.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)
                        let newYesResults1 = newYesResults.replacingOccurrences(of: "\n\n", with: "", options: NSString.CompareOptions.literal, range: nil)
                        
                        self.yesResults.append(newYesResults1)
                        
                    }
                    
                    
                    print(self.yesResults)
                    print(self.yesResults.count)
                    self.getPic1()
                    
                } else {
                    
                    print(error!)
                    
                }
                
            })
            
        } else {
            
            self.getPic1()
        }
        
    }
    
    func getQuizNoArray(){
        
        if noResults == []{
            let query = PFQuery(className:"Quiz")
            query.whereKey("jew", equalTo: "n")
            query.limit = 152 //no=152
            query.findObjectsInBackground(block: {
                (objects, error) in
                if error == nil {
                    
                    NSLog("Successfully retrieved \(objects!.count).")
                    
                    for object in objects! {
                        
                        let name = object["fullname"] as! String
                        let newNoResults = name.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)
                        let newNoResults1 = newNoResults.replacingOccurrences(of: "\n\n", with: "", options: NSString.CompareOptions.literal, range: nil)
                        self.noResults.append(newNoResults1)
                        
                    }
                    
                    print(self.noResults)
                    print(self.noResults.count)
                    
                    self.getPic2()
                    
                } else {
                    
                    print(error!)
                    
                }
                
            })
            
        } else {
            
            self.getPic2()
        }
        
    }
    
    var randNum1 = Int()
    
    func getPic1() {
        
        randNum1 = Int(arc4random_uniform(196))
        
        print(randNum1)
        
        let trimmed = yesResults[randNum1].trimmingCharacters(in: CharacterSet.whitespaces)
        
        let url = "http://whojew.bettersearchllc.com/images/thumbs/" + trimmed + ".jpg"
        
        let newLabel = yesResults[randNum1].replacingOccurrences(of: "_", with: " ", options: NSString.CompareOptions.literal, range: nil)
        
        let imgURL: URL = URL(string: url)!
        
        let request: URLRequest = URLRequest(url: imgURL)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(data, response, error) -> Void in
            if error == nil {
                
                let imgGet = UIImage(data: response!)
                
                if self.randNum1 < 88 {
                    
                    if imgGet != nil {
                        
                        self.pic1.image = UIImage(data: response!)
                        self.label1.text = newLabel
                        self.tapRec1.addTarget(self, action: #selector(QuizViewController.tappedYes))
                        self.pic1.addGestureRecognizer(self.tapRec1)
                        self.pic1.isUserInteractionEnabled = true
                        
                    } else {
                        
                        self.pic1.image = UIImage(named: "female-placeholder.png")
                        self.label1.text = newLabel
                        self.tapRec1.addTarget(self, action: #selector(QuizViewController.tappedYes))
                        self.pic1.addGestureRecognizer(self.tapRec1)
                        self.pic1.isUserInteractionEnabled = true
                        
                    }
                    
                } else {
                    
                    if imgGet != nil {
                        
                        self.pic2.image = UIImage(data: response!)
                        self.label2.text = newLabel
                        self.tapRec1.addTarget(self, action: #selector(QuizViewController.tappedYes))
                        self.pic2.addGestureRecognizer(self.tapRec1)
                        self.pic2.isUserInteractionEnabled = true
                        
                        
                    } else {
                        
                        self.pic2.image = UIImage(named: "female-placeholder.png")
                        self.label2.text = newLabel
                        self.tapRec1.addTarget(self, action: #selector(QuizViewController.tappedYes))
                        self.pic2.addGestureRecognizer(self.tapRec1)
                        self.pic2.isUserInteractionEnabled = true
                        
                    }
                    
                }
                
            } else {
                print(error!)
            }
        } )//as! (URLResponse?, Data?, Error?) -> Void)
        
        
    }
    
    func getPic2() {
        
        let randNum = Int(arc4random_uniform(152))
        
        print(randNum)
        
        let trimmed = noResults[randNum].trimmingCharacters(in: CharacterSet.whitespaces)
        
        let url = "http://whojew.bettersearchllc.com/images/thumbs/nonjews/" + trimmed + ".jpeg"
        
        let newLabel = noResults[randNum].replacingOccurrences(of: "_", with: " ", options: NSString.CompareOptions.literal, range: nil)
        
        let imgURL: URL = URL(string: url)!
        
        let request: URLRequest = URLRequest(url: imgURL)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(data, response, error) -> Void in
            if error == nil {
                
                let imgGet = UIImage(data: response!)
                
                if self.randNum1 < 88 {
                    
                    if imgGet != nil {
                        
                        self.pic2.image = UIImage(data: response!)
                        self.label2.text = newLabel
                        self.tapRec2.addTarget(self, action: #selector(QuizViewController.tappedNo))
                        self.pic2.addGestureRecognizer(self.tapRec2)
                        self.pic2.isUserInteractionEnabled = true
                        
                        
                        
                    } else {
                        
                        self.pic2.image = UIImage(named: "female-placeholder.png")
                        self.label2.text = newLabel
                        self.tapRec2.addTarget(self, action: #selector(QuizViewController.tappedNo))
                        self.pic2.addGestureRecognizer(self.tapRec2)
                        self.pic2.isUserInteractionEnabled = true
                        
                    }
                    
                } else {
                    
                    if imgGet != nil {
                        
                        self.pic1.image = UIImage(data: response!)
                        self.label1.text = newLabel
                        self.tapRec2.addTarget(self, action: #selector(QuizViewController.tappedNo))
                        self.pic1.addGestureRecognizer(self.tapRec2)
                        self.pic1.isUserInteractionEnabled = true
                        
                        
                    } else {
                        
                        self.pic1.image = UIImage(named: "female-placeholder.png")
                        self.label1.text = newLabel
                        self.tapRec2.addTarget(self, action: #selector(QuizViewController.tappedNo))
                        self.pic1.addGestureRecognizer(self.tapRec2)
                        self.pic1.isUserInteractionEnabled = true
                        
                    }
                    
                }
                
            } else {
                print(error!)
            }
        }) //as! (URLResponse?, Data?, Error?) -> Void)
        
        
    }
    
    @objc func tappedYes(){
        
        print("Yes Tapped")
        
        let alert = UIAlertController(title: "Awesome!", message: "You got it right.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            self.play()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @objc func tappedNo(){
        
        print("No Tapped")
        
        let alert = UIAlertController(title: "Sorry!", message: "That's incorrect.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            self.play()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
