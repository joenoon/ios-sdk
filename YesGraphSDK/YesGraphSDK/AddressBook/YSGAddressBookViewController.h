//
//  YSGAddressBookViewController.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import UIKit;

#import "YSGInviteService.h"

@interface YSGAddressBookViewController : UITableViewController

@property (nullable, nonatomic, weak) YSGInviteService *service;

@end
