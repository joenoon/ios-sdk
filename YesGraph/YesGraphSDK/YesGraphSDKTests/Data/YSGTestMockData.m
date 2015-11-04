//
//  YSGTestMockData.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGTestMockData.h"
#import "YSGTestSettings.h"

@implementation YSGTestMockData

+ (YSGContactList *)mockContactList
{
    YSGContactList *contactList = [[YSGContactList alloc] init];

    contactList.source = [YSGSource new];
    
    NSDictionary *contact1 = @{ @"name" : @"Milton Fuller", @"emails" : @[ @"milton.fuller@mymockdata.com", @"milton.fuller95@example.com" ], @"phones" : @[ @"+1 (956)-886-4918", @"+22 (956)-886-4918" ] };
    
    NSDictionary *contact2 = @{ @"name" : @"Ronald Elliott", @"emails" : @[ @"ronald.elliott93@mymockdata.com" ], @"phones" : @[ @"+1 (640)-169-9195", @"+22 (640)-169-1111" ] };
    
    NSDictionary *contact3 = @{ @"name" : @"Pauline Richardson", @"phones" : @[ @"+1 (146)-877-8411", @"+22 (146)-277-8411" ] };
    
    NSDictionary *contact4 = @{ @"name" : @"Samantha Howard", @"emails" : @[ ], @"phones" : @[ @"+1 5(130)-663-8780", @"+22 (130)-344-8780" ] };
    
    NSDictionary *contact5 = @{ @"name" : @"Troy Bell", @"emails" : @[ @"troy.bell87@mymockdata.com", @"troy.bell897@mymockdata.com" ] };
    
    NSDictionary *contact6 = @{ @"name" : @"Sue Reed", @"emails" : @[ @"sue.reed37@mymockdata.com", @"sue.reed372@mymockdata.com" ], @"phones" : @[ ] };
    
    NSDictionary *contact7 = @{ @"name" : @"Howard Daniels", @"emails" : @[ @"howard.daniels64@mymockdata.com" ], @"phones" : @[ @"+1 (798)-494-6469" ] };
    
    NSDictionary *contact8 = @{ @"name" : @"Charlotte Hoffman", @"phones" : @[ @"+1 (495)-692-7296" ] };
    NSDictionary *contact9 = @{ @"phones" : @[ @"+1 (495)-692-4416", @"+386 11 220 233" ] };
    NSDictionary *contact10 = @{ @"phones" : @[ @"+386 11 221 233" ] };
    
    NSDictionary *contact11 = @{ @"phones" : @[ @"+1 (495)-123-4416" ] };
    
    NSDictionary *contact12 = @{ @"emails" : @[ @"christine.bell12@mymockdata.com" ], @"phones" : @[ @"+1 (798)-494-6121" ] };
    NSDictionary *contact13 = @{ @"emails" : @[ @"marion.richards11@mymockdata.com" ] };
    NSDictionary *contact14 = @{ @"emails" : @[ @"camila.harrison21@mymockdata.com", @"camila.harrisssson55@mymockdata.com", @"camilla.harrissssson1967@mymockdata.com" ] };
    NSDictionary *contact15 = @{ @"name" : @"★ Steven Smith", @"emails" : @[ @"steven.smith15@mymockdata.com" ] };
    NSDictionary *contact16 = @{ @"name" : @"(Shane) Shannon Hill", @"emails" : @[ @"shannon.shannon788@mymockdata.com" ] };
    NSDictionary *contact17 = @{ @"name" : @"* Manuela Velasco", @"emails" : @[ @"manuela.man.velasco11@mymockdata.com" ] };
    NSDictionary *contact18 = @{ @"name" : @"15512 Some Address", @"phones" : @[ @"+1 (495)-331-4222" ] };
    NSDictionary *contact19 = @{ @"name" : @"441 Some Address", @"phones" : @[ @"+1 (555)-119-4222" ] };
    NSDictionary *contact20 = @{ @"name" : @"*$%/( Random name", @"phones" : @[ @"+1 (555)-119-3355" ] };
    
    YSGContact *parsedContact1 = [YSGContact ysg_objectWithDictionary:contact1];
    YSGContact *parsedContact2 = [YSGContact ysg_objectWithDictionary:contact2];
    YSGContact *parsedContact3 = [YSGContact ysg_objectWithDictionary:contact3];
    YSGContact *parsedContact4 = [YSGContact ysg_objectWithDictionary:contact4];
    YSGContact *parsedContact5 = [YSGContact ysg_objectWithDictionary:contact5];
    YSGContact *parsedContact6 = [YSGContact ysg_objectWithDictionary:contact6];
    YSGContact *parsedContact7 = [YSGContact ysg_objectWithDictionary:contact7];
    YSGContact *parsedContact8 = [YSGContact ysg_objectWithDictionary:contact8];
    YSGContact *parsedContact9 = [YSGContact ysg_objectWithDictionary:contact9];
    YSGContact *parsedContact10 = [YSGContact ysg_objectWithDictionary:contact10];
    YSGContact *parsedContact11 = [YSGContact ysg_objectWithDictionary:contact11];
    YSGContact *parsedContact12 = [YSGContact ysg_objectWithDictionary:contact12];
    YSGContact *parsedContact13 = [YSGContact ysg_objectWithDictionary:contact13];
    YSGContact *parsedContact14 = [YSGContact ysg_objectWithDictionary:contact14];
    YSGContact *parsedContact15 = [YSGContact ysg_objectWithDictionary:contact15];
    YSGContact *parsedContact16 = [YSGContact ysg_objectWithDictionary:contact16];
    YSGContact *parsedContact17 = [YSGContact ysg_objectWithDictionary:contact17];
    YSGContact *parsedContact18 = [YSGContact ysg_objectWithDictionary:contact18];
    YSGContact *parsedContact19 = [YSGContact ysg_objectWithDictionary:contact19];
    YSGContact *parsedContact20 = [YSGContact ysg_objectWithDictionary:contact20];
    
    contactList.entries = @[ parsedContact1, parsedContact2, parsedContact3, parsedContact4, parsedContact5, parsedContact6, parsedContact7, parsedContact8, parsedContact9, parsedContact10, parsedContact11, parsedContact12, parsedContact13, parsedContact14, parsedContact15, parsedContact16, parsedContact17, parsedContact18, parsedContact19, parsedContact20 ];
    
    return contactList;
}

@end
