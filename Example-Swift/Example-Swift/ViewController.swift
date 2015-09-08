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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func shareButtonTap(sender: UIButton) {
        let localSource = YSGLocalContactSource()
        localSource.contactAccessPromptMessage = "Share contacts with Example-Swift to invite friends?"
        
        let onlineSource = YSGOnlineContactSource(client: YSGClient(), localSource: localSource, cacheSource: YSGCacheContactSource())
        
        let inviteService = YSGInviteService(contactSource: onlineSource, userId: nil)
        
        let shareController = YSGShareSheetController(services: [YSGFacebookService(), YSGTwitterService(), inviteService], delegate: self)
        
        self.navigationController?.pushViewController(shareController, animated: true)
    }
    
    func shareSheetController(shareSheetController: YSGShareSheetController, messageForService service: YSGShareService, userInfo: [NSObject : AnyObject]?) -> [NSObject : AnyObject] {
        
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
    
}

