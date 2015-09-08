//
//  YSGLog.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGLog.h"

@implementation YSGLog

- (void)print
{
    NSLog(@"[%@:%@] %@ [Line %luld]: %@", YSGLogLevelString(self.level), self.file, self.function, (unsigned long)self.line, self.message);
}

@end
