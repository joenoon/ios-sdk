//
//  YSGShareSheetControllerMock.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 20/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareSheetControllerMock.h"

@implementation YSGShareSheetControllerMock

- (nullable NSDictionary<NSString *, id> *)shareService:(YSGShareService *)shareService messageWithUserInfo:(nullable NSDictionary <NSString *, id>*)userInfo
{
    return nil;
}

- (void)shareService:(YSGShareService *)shareService didShareWithUserInfo:(nullable NSDictionary <NSString *, id> *)userInfo error:(nullable NSError *)error
{
    
}

@end