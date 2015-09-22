//
//  ParseBackend.h
//  Example
//
//  Created by Miha Gresak on 21/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseBackend : NSObject

@property (strong, nonatomic) NSString *YGclientKey;

- (id)initWithUserId:(NSString *)userId;

@end
