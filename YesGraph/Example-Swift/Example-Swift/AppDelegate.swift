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
            
            // Give your user a unique UserID here. This should be unique for each user of your app.
            let userId: String = YSGUtility.randomUserId()
            YesGraph.shared().configureWithUserId(userId)
            
            //
            // Configuring the source of contacts really helps us working with contacts.
            //
            let source = YSGSource()
            source.name = "Name"
            source.email = "Email"
            source.phone = "+1 123 123 123"
            
            YesGraph.shared().contactOwnerMetadata = source
            
        }
        if YesGraph.shared().clientKey == nil {
            
            let urlPath: String = "https://yesgraph-client-key-test.herokuapp.com/client-key/" + YesGraph.shared().userId!
            let url: NSURL = NSURL(string: urlPath)!
            let request: NSURLRequest = NSURLRequest(URL: url)
            let session: NSURLSession = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                
                let jsonResult: NSDictionary = try! (NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary)!
                print("AsSynchronous\(jsonResult)")
                
                YesGraph.shared().configureWithClientKey(jsonResult["message"] as! String)
                
            });
            task.resume()

        }
        
        return true
    }
}
