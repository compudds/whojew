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

    @IBAction func email(_ sender: AnyObject) {
      
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
        
        self.present(mc, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        scroll.addSubview(aboutLabel)
        
        self.navigationController?.isNavigationBarHidden = true

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
