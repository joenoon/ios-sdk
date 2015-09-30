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
        
        
        theme.baseColor = UIColor.redColor();
        if let addrBookTheme = theme.shareAddressBookTheme {
            addrBookTheme.viewBackground = UIColor.redColor().colorWithAlphaComponent(0.38);
        }
        // Welcome Screen
        theme.textColor = UIColor.whiteColor()
        
        super.viewDidLoad()
        
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
    }
    
    @IBOutlet weak var introTextField: UITextField!
    @IBOutlet weak var additionalInfoLabel: UILabel!

    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var additionalNotesView: UIView!

    @IBAction func shareButtonTapped(sender: AnyObject) {
        let localSource = YSGLocalContactSource()
        localSource.contactAccessPromptMessage = "Share contacts with Example-Swift to invite friends?"
        
        let onlineSource = YSGOnlineContactSource(client: YSGClient(), localSource: localSource, cacheSource: YSGCacheContactSource())
        
        let inviteService = YSGInviteService(contactSource: onlineSource, userId: nil)
        inviteService.theme = theme
        
        let facebookService = YSGFacebookService()
        facebookService.theme = theme
        
        let twitterService = YSGTwitterService()
        twitterService.theme = theme
        
        let shareController = YSGShareSheetController(services: [ facebookService, twitterService, inviteService], delegate: self)
        shareController.baseColor = theme.baseColor
        
        // OPTIONAL
        
        //
        // set referralURL if you have one, leave blank if you don't
        shareController.referralURL = "hellosunschein.com/dkjh34";
        //
        
        //
        // PRESENT MODALLY - un/comment next 2 lines
        //
        
        // self.presentViewController(shareController, animated: true, completion: nil)
        
        //
        // PRESENT ON NAVIGATION STACK - un/comment next 1 line
        //
        
        self.navigationController?.pushViewController(shareController, animated: true)
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

