//
//  ViewController.swift
//  Example-Swift
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 Dal Rupnik. All rights reserved.
//

import UIKit
import YesGraphSDK
import Social

class ViewController: UIViewController, YSGShareSheetDelegate, UIWebViewDelegate {

    var theme = YSGTheme()

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Home"
        
        self.setWebViewContent()
        
        self.webView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func setWebViewContent() -> Void {
        let htmlString = "<style>a:link {color:#487EA8; text-decoration:none}a:visited {color:#487EA8; text-decoration:none}</style>" +
        "<body style=\"font-family: 'Open Sans'; font-size: 15px; margin: 0; background-color: #1F2124; text-align: left; color: #C4C6C7;\">It’s open source. <a href=\"https://github.com/YesGraph/ios-sdk\">Find it on Github here</a>. <br><br>" +
        "If you use CocoaPods, you can integrate with: pod 'YesGraph-iOS-SDK' Or with Carthage: github \"YesGraph/ios-sdk\" <br><br>" +
        "We have example applications using <a href=\"https://github.com/YesGraph/ios-sdk#example-applications\">(Parse, Swift, and Objective-C)</a> on Github.<br><br>" +
        "You’ll need a YesGraph account. <a href=\"https://www.yesgraph.com/\">Sign up and create an app to configure the SDK</a>.<br><br>" +
        "The documentation online is extensive, but if you have any trouble, email <a href=\"mailto:support@yesgraph.com\">support@yesgraph.com</a>.</body>"
        self.webView.opaque = false
        self.webView.backgroundColor = UIColor.clearColor()
        self.webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    
    
    func isAvailableTwit(empty: String) -> Bool {
        return empty == SLServiceTypeTwitter
    }
    
    func isAvailableBoth(empty: String) -> Bool {
        return true
    }
    
    func isAvailableNone(empty: String) -> Bool {
        return false
    }
    
    func setString(str: String) {
        NSLog("Set string called with %@ from %s", str, __FILE__)
    }

    @IBAction func shareButtonTap(sender: UIButton) {
        
        if YesGraph.shared().isConfigured
        {
            self.presentShareSheetController()
        }
        else
        {
            sender.setTitle("setting up...", forState: UIControlState.Normal);
            sender.enabled = false;

            self.configureYesGraphWithCompletion({ (success, error) -> Void in
                sender.setTitle("Try YesGraph", forState: UIControlState.Normal)
                sender.enabled = true;
                
                if (success)
                {
                    self.presentShareSheetController()
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
    
    func presentShareSheetController() {
        YesGraph.shared().theme = self.theme
        YesGraph.shared().numberOfSuggestions = 5
        YesGraph.shared().contactAccessPromptMessage = "Share contacts with Example to invite friends?"
        YesGraph.shared().shareSheetText = "Demo our SDK by sharing YesGraph with your contacts"
        
        let shareController = YesGraph.shared().shareSheetControllerForAllServicesWithDelegate(self)
        
        // OPTIONAL
        
        // set referralURL if you have one
        shareController!.referralURL = "www.yesgraph.com/#iosg";
        
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
            if YesGraph.shared().isConfigured
            {
                completion!(success: true, error: nil);
            }
            else
            {
                completion!(success: false, error: nil);
            }
        }
    }
    
    func shareSheetController(shareSheetController: YSGShareSheetController, messageForService service: YSGShareService, userInfo: [String : AnyObject]?) -> [String : AnyObject] {
        
        if let _ = service as? YSGFacebookService {
            return [YSGShareSheetMessageKey : "YesGraph helps your app grow. Check it out! www.yesgraph.com/#iosfb"]
        }
        else if let _ = service as? YSGTwitterService {
            return [YSGShareSheetMessageKey : "YesGraph helps your app grow. Check it out! www.yesgraph.com/#iostw"]
        }
        else if let _ = service as? YSGInviteService {
            if let _ = userInfo?[YSGInviteEmailContactsKey] {
                return [YSGShareSheetSubjectKey : "We should check out YesGraph",
                        YSGShareSheetMessageKey : "Check out YesGraph, they help apps grow: www.yesgraph.com/#iosce"]
            }
            else {
                return [YSGShareSheetMessageKey : "Check out YesGraph, they help apps grow: www.yesgraph.com/#iosce"]
            }
        }
        
        return [YSGShareSheetMessageKey : ""]
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        if navigationType == .LinkClicked
        {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false;
        }
        else
        {
            return true;
        }
    }

}

