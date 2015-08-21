//
//  YSGShareSheetController.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareSheetController.h"

@interface YSGShareSheetController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) YSGTheme *theme;

@end

@implementation YSGShareSheetController

#pragma mark - Initialization

+ (instancetype _Nonnull)shareSheetControllerWithServices:(NSArray<YSGShareService *> * _Nonnull)services
{
    return [[self alloc] initWithServices:services delegate:nil];
}

- (instancetype)initWithServices:(NSArray<YSGShareService *> *)services delegate:(id<YSGShareSheetDelegate>)delegate
{
    return [self initWithServices:services delegate:delegate theme:nil];
}

- (instancetype)initWithServices:(NSArray<YSGShareService *> *)services delegate:(id<YSGShareSheetDelegate>)delegate theme:(YSGTheme * _Nullable)theme
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // Setup views
    //
}

#pragma mark - UICollectionViewDataSource

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
