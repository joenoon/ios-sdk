//
//  YSGShareSheetController.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareSheetController.h"
#import "YSGShareSheetServiceCell.h"

static NSString *const YSGShareSheetCellIdentifier = @"YSGShareSheetCellIdentifier";

@interface YSGShareSheetController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) YSGTheme *theme;

@property (nonatomic, copy) NSArray <YSGShareService *> *services;

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
        self.services = services;
        self.delegate = delegate;
        self.theme = theme;
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    //
    // Setup views
    //
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[YSGShareSheetServiceCell class] forCellWithReuseIdentifier:YSGShareSheetCellIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionView *collectionView = self.collectionView;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
    
    [self.view addSubview:self.collectionView];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[collectionView]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[collectionView]-100-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    [self.view layoutIfNeeded];

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.services.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSGShareSheetServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YSGShareSheetCellIdentifier forIndexPath:indexPath];
    
    YSGShareService *service = self.services[indexPath.row];
    
    if (!cell)
    {
        cell = [[YSGShareSheetServiceCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.text = service.name;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSGShareService *service = self.services[indexPath.row];
    
    [service triggerServiceWithViewController:self];
}

@end
