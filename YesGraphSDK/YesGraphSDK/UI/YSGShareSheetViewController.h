//
//  YSGShareSheetViewController.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

@import UIKit;

#import "YSGShareService.h"

@interface YSGShareSheetViewController : UIViewController

/*!
 *  Returns new instance of Share Sheet view controller
 *
 *  @param services to use in share sheet
 *
 *  @return new view controller instance to be displayed
 */
+ (instancetype)shareSheetWithServices:(NSArray<YSGShareService *> *)services;

@end
