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
    
    @IBAction func backToHome(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "slideshowToHome", sender: self)
        
    }
    
    @IBAction func moreSlides(_ sender: AnyObject) {
        
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
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.navigationController?.isNavigationBarHidden = false
        
        if yesResults == [] {
            
            getQuizYesArray()
        
        } else {
            
        }
        self.collectionView!.delegate = self
        
        self.collectionView!.dataSource = self
        
        self.view.addSubview(collectionView!)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        noInternetConnection()
        
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
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(LayoutController.noInternetConnection), userInfo: nil, repeats: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 250
    }
    
    func getQuizYesArray(){
        
        for _ in 0..<500 {
            
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
            query.findObjectsInBackground(block: {
                (objects, error) in
                
                if error == nil {
            
                    NSLog("Successfully retrieved \(objects!.count).")
                    countObj = objects!.count
                    for object in objects! {
                        
                        newRel1.append(object["cat"] as! String)
                        let name = object["fullname"] as! String
                        let newYesResults = name.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)
                        let newYesResults1 = newYesResults.replacingOccurrences(of: "\n\n", with: "", options: NSString.CompareOptions.literal, range: nil)
                        
                        yesResults.append(newYesResults1)
                        
                        
                    }
                    
                    
                    print(yesResults)
                    print(yesResults.count)
                    
                    self.getPic1()
                    
                    
                } else {
                    
                    print(error!)
                    
                    
                }
                
            })
            
        } else {
            
            self.getPic1()
            
        }
            
        //}
     
    }

    func getPic1() {
    
        for i in 0..<countObj {
            
            //randNum1 = Int(arc4random_uniform(300))
            
            let trimmed = yesResults[i].trimmingCharacters(in: CharacterSet.whitespaces)
            
            urls = ["http://whojew.bettersearchllc.com/images/thumbs/" + trimmed + ".jpg"] + urls
            
            names = [yesResults[i].replacingOccurrences(of: "_", with: " ", options: NSString.CompareOptions.literal, range: nil)] + names
            
            let newRelReOrder = [newRel1[i]]
            
            newRel2 = newRelReOrder + newRel2
            
        }
        
        print("\(urls)")
        print("\(names)")
        print("\(names.count)")
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        if names == [] {
            
            
            
        } else {
            
            cell.label.text = names[indexPath.row % 1000]
            
            let urlPath = urls[indexPath.row % 1000]
            
            let imgURL: URL = URL(string: urlPath)!
            
            let request: URLRequest = URLRequest(url: imgURL)
            
            /*NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(response: URLResponse?,data: Data?,error: NSError?) -> Void in
            
            var request = NSMutableURLRequest(URL: NSURL(string: "YOUR URL")!)
            var session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            var params = ["username":"username", "password":"password"] as Dictionary<String, String>
            
            request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                print("Response: \(response)")})*/

            
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(data, response, error) -> Void in
                
                if error == nil {
                    
                    //cell.img.image = UIImage(data: data)
                    cell.img.image = UIImage(data: response!)
                    self.tapRec1.addTarget(self, action: #selector(LayoutController.tapped))
                    cell.img.addGestureRecognizer(self.tapRec1)
                    cell.img.isUserInteractionEnabled = true
                    
                    
                } else {
                    print(error!)
                    
                }
            //} as! (URLResponse?, Data?, Error?) -> Void)
            } )//as! (data, response, error) -> Void)
        

        
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.cellForItem(at: indexPath)!
        let fullNameArr = names[indexPath.row].components(separatedBy: " ")
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
    
    @objc func tapped(){
        
        print("Tapped")
        
        self.performSegue(withIdentifier: "slideshowToSingle", sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 170, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
}
