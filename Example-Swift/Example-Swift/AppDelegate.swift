//
//  AppDelegate.swift
//  Example-Swift
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 Dal Rupnik. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static let ParseApplicationID : String = "BU2njCAM4ZGNHuh2meG9Ca3zkBjqlbUd1WSwHmGG";
    static let ParseClientKey : String = "o7bc0AL0X2gmE5eh1doecNSJPKjS6VtpVx1kaEzG";
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        Parse.setApplicationId(AppDelegate.ParseApplicationID, clientKey: AppDelegate.ParseClientKey);
        
        return true;
    }
    
}
