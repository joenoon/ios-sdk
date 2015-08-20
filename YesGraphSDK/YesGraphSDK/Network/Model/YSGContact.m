//
//  YSGContact.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGContact.h"

@implementation YSGContact

- (NSString *)phone
{
    return self.phones.firstObject;
}

- (NSString *)email
{
    return self.emails.firstObject;
}

- (NSString *)contactString
{
    return self.phone ?: self.email;
}

@end
