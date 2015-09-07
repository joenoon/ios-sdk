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

@property (nonatomic, copy, readwrite) NSArray <YSGShareService *> *services;

@end

@implementation YSGShareSheetController
{
    float cellWidth;
}

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
    
    // self.theme.mainColor
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.9 green:0.11 blue:0.17 alpha:1];
    self.title = @"Share";
    
    //    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //
    // Setup views
    //
    
    cellWidth = self.view.frame.size.width/5;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
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
    // footer currently invisible because it's unclear whether it will be used or not
    footer.backgroundColor = [UIColor clearColor];
    
    UIView* header = [[UIView alloc] init];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    //header.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    header.backgroundColor = [UIColor clearColor];
    
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
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeHeight multiplier:0.65 constant:1]];
    
    [self.view layoutIfNeeded];
    
    //  OPTIONAL
    //  Share text label
    //
    
    float width = header.frame.size.width;
    float height = header.frame.size.height;
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width * 0.9, 100)];
    shareLabel.text = @"Share YesGraph with your friends, family, coworkers, your cat... We might even give you something. Maybe a sticker?";
    shareLabel.font = [UIFont systemFontOfSize:16.f];
    shareLabel.textColor = [UIColor colorWithRed:82/256.0 green:82/256.0 blue:82/256.0 alpha:1];
    shareLabel.lineBreakMode = NSLineBreakByWordWrapping;
    shareLabel.numberOfLines = 0;
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    [shareLabel sizeToFit];
    shareLabel.center = CGPointMake(width/2, height * 0.7);
    
    [header addSubview:shareLabel];
    
    //  OPTIONAL
    //  Company logo
    //
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    
    logoView.center = CGPointMake(width/2, height * 0.3);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.backgroundColor = [UIColor clearColor];
    
    [header addSubview:logoView];
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
    
    
    cell.text = service.callToAction;
    // Shapes == Circle, RoundedSquare, or Square
    cell.cellShape = @"Circle";
    // Twitter, facebook and phone images
    cell.icon = service.serviceImage;
    cell.backgroundColor = service.color;
    cell.font = [UIFont systemFontOfSize:14];
    
    // color for the service label font - based on brand colors for Twitter, fb & the app that's
    // integrating the service
    //cell.color = service.color;
    
    cell.color = [UIColor colorWithRed:82/256.0 green:82/256.0 blue:82/256.0 alpha:1];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSGShareService *service = self.services[indexPath.row];
    
    YSGShareSheetServiceCell *cell = (YSGShareSheetServiceCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    [self fadeCell:cell forService:service];
    
    if ([self.delegate respondsToSelector:@selector(shareSheetController:didSelectService:)])
    {
        [self.delegate shareSheetController:self didSelectService:service];
    }
    
    [service triggerServiceWithViewController:self];
    
    [self unfadeCell:cell forService:service];
}

- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    float cellSpacing = 10.f;
    
    // centers cell section in container horizontally
    float containerWidth = collectionView.frame.size.width;
    float horizontalEdgeInset = containerWidth - (3 * cellWidth + 2 * cellSpacing);
    
    return UIEdgeInsetsMake(0 * 0.25, horizontalEdgeInset * 0.4, 0, horizontalEdgeInset * 0.4);
}


#pragma mark - Helpers

// cell tap/selection animations
- (void) fadeCell:(YSGShareSheetServiceCell *)cell forService:(YSGShareService *)service {
    [UIView animateWithDuration:0.2 animations:^{
        cell.backgroundColor = [service.color colorWithAlphaComponent:0.8];
    }];
}

- (void) unfadeCell:(YSGShareSheetServiceCell *)cell forService:(YSGShareService *)service {
    [UIView animateWithDuration:0.4 animations:^{
        cell.backgroundColor = [service.color colorWithAlphaComponent:1.0];
    }];
}


@end
