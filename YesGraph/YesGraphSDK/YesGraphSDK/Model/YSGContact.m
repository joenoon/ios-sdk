//
//  YSGContact.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGContact.h"

NSString* const YSGContactSuggestedKey = @"suggested";

@implementation YSGContact

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.name, self.contactString];
}

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
    return self.email ?: self.phone;
}

- (NSString *)sanitizedName
{
    return [self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)wasSuggested
{
    return [self.data[YSGContactSuggestedKey] boolValue];
}

- (void)setSuggested:(BOOL)suggested
{
    NSMutableDictionary *data = [self.data mutableCopy];
    
    if (data)
    {
        data = [NSMutableDictionary dictionary];
    }
    
    if (suggested)
    {
        data[YSGContactSuggestedKey] = @(YES);
    }
    else
    {
        [data removeObjectForKey:YSGContactSuggestedKey];
    }
}

@end
