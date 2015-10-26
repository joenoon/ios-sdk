//
//  YSGShareService.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareService.h"

@implementation YSGShareService

- (void)triggerServiceWithViewController:(nonnull YSGShareSheetController *)viewController
{
    [NSException raise:@"Not implemented for generic share service." format:@"This method is abstract and must not be used called directly, use subclasses."];
}

- (NSString *)fontFamily
{
    return self.theme.fontFamily;
}

- (UIColor *)textColor
{
    return self.theme.textColor;
}

- (YSGShareSheetServiceCellShape)shape
{
    return self.theme.shareButtonShape;
}


@end
