//
//  AboutViewController.swift
//  WhoJew
//
//  Created by Eric Cook on 3/22/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate, UIScrollViewDelegate {

    @IBAction func email(sender: AnyObject) {
      
        sendEmail()
        
    }
    
    @IBOutlet var aboutLabel: UILabel!
    
    @IBOutlet var scroll: UIScrollView!
    
    
    func sendEmail() {
        
        let toRecipents = ["whojew@bettersearchllc.com"] as [String]
        //var toRecipents: [String] = iPathEmail as [String]
        print(toRecipents)
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        
        //mc.setSubject("Hi, we accepted each other on Tinder. Let's talk!")
        
        //mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        scroll.addSubview(aboutLabel)
        
        self.navigationController?.navigationBarHidden = true

    }
    
    override func viewDidLayoutSubviews() {
        
        self.scroll.contentSize = CGSize(width: 257, height: 1000)
        
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
