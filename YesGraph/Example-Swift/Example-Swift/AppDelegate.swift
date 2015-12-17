//
//  AppDelegate.swift
//  Example-Swift
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 Dal Rupnik. All rights reserved.
//

import UIKit
import YesGraphSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        //
        // Configures YesGraph with a specific User ID and Source, so we know where are contacts from.
        //
        if YesGraph.shared().userId == nil {
            YesGraph.shared().configureWithUserId(YSGUtility.randomUserId())
            
            //
            // Configuring the source of contacts really helps us working with contacts.
            //
            /*let source = YSGSource()
            source.name = "Name"
            source.email = "Email"
            source.phone = "+1 123 123 123"
            
            YesGraph.shared().contactOwnerMetadata = source*/
        }
        
        //
        // Client key should be retrieved from your trusted backend and is cached in the YesGraph SDK.
        // If user logins with another user ID, new client key must be configured.
        //
        YesGraph.shared().configureWithClientKey("")
        
        return true
    }
}
