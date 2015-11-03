//
//  YSGMockedUISearchController.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 03/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSGMockedUISearchBar : UISearchBar

@property (strong, nonatomic) NSString *mockedSearchText;

@end

@interface YSGMockedUISearchController : UISearchController

@property (strong, nonatomic, readwrite) UISearchBar *searchBar;

- (instancetype)initWithSearch:(NSString *)mockedSearch;

@end
