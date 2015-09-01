//
//  YSGShareSheetController.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareSheetController.h"
#import "YSGShareSheetServiceCell.h"

NSString *_Nonnull const YSGShareSheetMessageKey = @"YSGShareSheetMessageKey";

static NSString *const YSGShareSheetCellIdentifier = @"YSGShareSheetCellIdentifier";

@interface YSGShareSheetController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) YSGTheme *theme;

@property (nonatomic, copy) NSArray <YSGShareService *> *services;

@end

@implementation YSGShareSheetController

#pragma mark - Getters and Setters

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
    self = [super initWithNibName:nil bundle:nil];
    
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
    
    self.title = @"Share";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //
    // Setup views
    //
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100.0, 100.0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[YSGShareSheetServiceCell class] forCellWithReuseIdentifier:YSGShareSheetCellIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    //
    // Referral link view
    //
    
    UIView* footer = [[UIView alloc] init];
    footer.translatesAutoresizingMaskIntoConstraints = NO;
    footer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    UIView* header = [[UIView alloc] init];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    header.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    [self.view addSubview:header];
    [self.view addSubview:footer];
    
    UICollectionView *collectionView = self.collectionView;
    
    [self.view addSubview:self.collectionView];
    
    UIView *superview = self.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(superview, header, footer, collectionView);
    
    //
    // Constraints
    //
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[collectionView]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[header]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[footer]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[header]-10-[collectionView(140)]-10-[footer(60)]" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeHeight multiplier:0.2 constant:1]];
    
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
        cell = [[YSGShareSheetServiceCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 150.0)];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.text = service.name;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSGShareService *service = self.services[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(shareSheetController:didSelectService:)])
    {
        [self.delegate shareSheetController:self didSelectService:service];
    }
    
    [service triggerServiceWithViewController:self];
}

@end
