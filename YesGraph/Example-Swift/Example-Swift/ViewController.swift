//
//  ViewController.swift
//  Example-Swift
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 Dal Rupnik. All rights reserved.
//

import UIKit
import YesGraphSDK

class ViewController: UIViewController, YSGShareSheetDelegate {

    var theme = YSGTheme()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        theme.baseColor = UIColor.redColor();
        
        super.viewDidLoad()
    }
    
    @IBOutlet weak var introTextField: UITextField!
    @IBOutlet weak var additionalInfoLabel: UILabel!

    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var additionalNotesView: UIView!

    @IBAction func shareButtonTap(sender: AnyObject) {
        let localSource = YSGLocalContactSource()
        localSource.contactAccessPromptMessage = "Share contacts with Example-Swift to invite friends?"
        
        if(YesGraph.shared().isConfigured)
        {
            self.presentYSGShareSheetController()
        }
        
        else
        {
            self.shareButton.setTitle("  Configuring YesGraph...  ", forState: UIControlState.Normal);
            self.shareButton.enabled = false;
            
            self.configureYesGraphWithCompletion({ (success, error) -> Void in
                self.shareButton.setTitle("Share", forState: UIControlState.Normal)
                self.shareButton.enabled = true;
                
                if (success)
                {
                    self.presentYSGShareSheetController()
                }
                else
                {
                    let alert = UIAlertController(title: "Error!", message: "YesGraphSDK must be configured before presenting ShareSheet", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    
    func presentYSGShareSheetController() {
        
        YesGraph.shared().theme = self.theme
        YesGraph.shared().numberOfSuggestions = 5
        YesGraph.shared().contactAccessPromptMessage = "Share contacts with Example to invite friends?"
        
        let shareController  = YesGraph.shared().shareSheetControllerForAllServicesWithDelegate(self)
        
        // OPTIONAL
        
        // set referralURL if you have one
        //shareController!.referralURL = "your-site.com/referral";
        
        //
        // PRESENT MODALLY
        //
        
        //let navController = UINavigationController.init(rootViewController: shareController!)
        //self.presentViewController(navController, animated: true, completion: nil)
        
        //
        // PRESENT ON NAVIGATION STACK
        //
        
        self.navigationController?.pushViewController(shareController!, animated: true)
    }

    func configureYesGraphWithCompletion(completion: ((success: Bool, error: NSError?) -> Void)?) {
        if YesGraph.shared().userId == nil {
            YesGraph.shared().configureWithUserId(YSGUtility.randomUserId())
        }
        
        YesGraph.shared().configureWithClientKey("")
        
        //
        // Client key should be retrieved from your trusted backend.
        //
        if completion != nil {
            completion!(success: false, error: nil);
        }
    }
    
    func shareSheetController(shareSheetController: YSGShareSheetController, messageForService service: YSGShareService, userInfo: [String : AnyObject]?) -> [String : AnyObject] {
        
        if let _ = service as? YSGFacebookService {
            return [YSGShareSheetMessageKey : "This message will be posted to Facebook."]
        }
        else if let _ = service as? YSGTwitterService {
            return [YSGShareSheetMessageKey : "This message will be posted to Twitter."]
        }
        else if let _ = service as? YSGInviteService {
            return [YSGShareSheetMessageKey : "This message will be posted to SMS."]
        }
        
        return [YSGShareSheetMessageKey : ""]
    }
    
    func styleView() {
        self.additionalInfoLabel.font = UIFont(name: "OpenSans", size: 16)
        self.introTextField.font = UIFont(name: "OpenSans-Semibold", size: 18)
        self.shareButton.titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        
        self.shareButton.layer.cornerRadius = self.shareButton.frame.size.height/10;
    }
    
}

