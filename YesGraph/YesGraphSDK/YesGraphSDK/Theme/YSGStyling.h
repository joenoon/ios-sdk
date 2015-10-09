//
//  YSGStyling.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

@class YSGTheme;

@protocol YSGStyling <NSObject>

- (void)applyTheme:(nonnull YSGTheme *)theme;

@end
