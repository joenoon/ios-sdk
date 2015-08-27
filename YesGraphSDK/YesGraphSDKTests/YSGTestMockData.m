//
//  YSGTestMockData.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGTestMockData.h"

@implementation YSGTestMockData

+ (YSGContactList *)mockContactList
{
    YSGContactList *contactList = [[YSGContactList alloc] init];
    
    contactList.userId = @"1234";
    
    contactList.source = [YSGSource userSource];
    
    NSDictionary *contact1 = @{ @"name" : @"Milton Fuller", @"emails" : @[ @"milton.fuller@example.com", @"milton.fuller95@example.com" ], @"phones" : @[ @"+1 (956)-886-4918", @"+22 (956)-886-4918" ] };
    
    NSDictionary *contact2 = @{ @"name" : @"Ronald Elliott", @"emails" : @[ @"ronald.elliott93@example.com" ], @"phones" : @[ @"+1 (640)-169-9195", @"+22 (640)-169-1111" ] };
    
    NSDictionary *contact3 = @{ @"name" : @"Pauline Richardson", @"phones" : @[ @"+1 (146)-877-8411", @"+22 (146)-277-8411" ] };
    
    NSDictionary *contact4 = @{ @"name" : @"Samantha Howard", @"emails" : @[ ], @"phones" : @[ @"+1 5(130)-663-8780", @"+22 (130)-344-8780" ] };
    
    NSDictionary *contact5 = @{ @"name" : @"Troy Bell", @"emails" : @[ @"troy.bell87@example.com", @"troy.bell897@example.com" ] };
    
    NSDictionary *contact6 = @{ @"name" : @"Sue Reed", @"emails" : @[ @"sue.reed37@example.com", @"sue.reed372@example.com" ], @"phones" : @[ ] };
    
    NSDictionary *contact7 = @{ @"name" : @"Howard Daniels", @"phones" : @[ @"howard.daniels64@example.com" ], @"phones" : @[ @"+1 (798)-494-6469" ] };
    
    NSDictionary *contact8 = @{ @"name" : @"Charlotte Hoffman", @"phones" : @[ @"+1 (495)-692-7296" ] };
    
    
    YSGContact *parsedContact1 = [YSGContact ysg_objectWithDictionary:contact1];
    YSGContact *parsedContact2 = [YSGContact ysg_objectWithDictionary:contact2];
    YSGContact *parsedContact3 = [YSGContact ysg_objectWithDictionary:contact3];
    YSGContact *parsedContact4 = [YSGContact ysg_objectWithDictionary:contact4];
    YSGContact *parsedContact5 = [YSGContact ysg_objectWithDictionary:contact5];
    YSGContact *parsedContact6 = [YSGContact ysg_objectWithDictionary:contact6];
    YSGContact *parsedContact7 = [YSGContact ysg_objectWithDictionary:contact7];
    YSGContact *parsedContact8 = [YSGContact ysg_objectWithDictionary:contact8];
    
    contactList.entries = @[ parsedContact1, parsedContact2, parsedContact3, parsedContact4, parsedContact5, parsedContact6, parsedContact7, parsedContact8 ];
    
    return contactList;
}

@end
