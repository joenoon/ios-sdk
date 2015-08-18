//
//  YSGAddressBookViewController.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import UIKit;

@interface YSGAddressBookViewController : UITableViewController

/*!
 *  Number of suggestions displayed above contacts.
 *
 *  @discussion: Default value is: 5
 */
@property (nonatomic, assign) NSUInteger numberOfSuggestions;

@end
