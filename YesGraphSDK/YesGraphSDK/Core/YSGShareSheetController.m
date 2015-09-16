//
//  YSGShareSheetController.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareSheetController.h"
#import "YSGShareSheetServiceCell.h"
#import "YSGTheme.h"

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
    
    self.title = NSLocalizedString(@"Share", @"Share");
    
    if (!self.theme)
    {
        self.theme = [YSGTheme new];
    }
    self.navigationController.navigationBar.tintColor = self.theme.mainColor;
    self.view.backgroundColor = self.theme.shareViewBackgroundColor;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //
    // Setup views
    //
    
    cellWidth = self.view.frame.size.width/5;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = self.theme.shareCollectionViewBackgroundColor;
    
    [self.collectionView registerClass:[YSGShareSheetServiceCell class] forCellWithReuseIdentifier:YSGShareSheetCellIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    //
    // Referral link view
    //
    
    UIView* footer = [[UIView alloc] init];
    footer.translatesAutoresizingMaskIntoConstraints = NO;
    footer.backgroundColor = self.theme.shareReferalViewBackgroundColor;
    
    //
    // Header container view - logo + text
    //
    UIView* header = [[UIView alloc] init];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    //  Company logo view
    
    UIImageView *logoView = [UIImageView new];
    
    logoView.translatesAutoresizingMaskIntoConstraints = NO;
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    //
    // Share text view
    
    // NOTE: fix the alignment maybe?
    
    UILabel *shareLabel = [UILabel new];
    
    shareLabel.translatesAutoresizingMaskIntoConstraints = NO;
    shareLabel.text = @"Share this app with friends to get our eternal gratitude";
    shareLabel.font = [UIFont fontWithName:self.theme.fontFamily size:self.theme.shareButtonLabelFontSize];
    shareLabel.textColor = self.theme.textColor;
    shareLabel.lineBreakMode = NSLineBreakByWordWrapping;
    shareLabel.numberOfLines = 0;
    //shareLabel.backgroundColor = [UIColor redColor];
    shareLabel.textAlignment = self.theme.shareLabelTextAlignment;
    [shareLabel sizeToFit];
    
    [header addSubview:shareLabel];
    
    [self.view addSubview:header];
    [header addSubview:logoView];
    [header addSubview:shareLabel];
    
    [self.view addSubview:footer];
    
    UICollectionView *collectionView = self.collectionView;
    [self.view addSubview:self.collectionView];
    
    UIView *superview = self.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(superview, header, footer, collectionView, shareLabel, logoView);
    
    //
    // Constraints
    //
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[collectionView]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[header]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[footer]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[shareLabel]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[logoView]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[header]-10-[collectionView(140)]-10-[footer(60)]" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[shareLabel]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeHeight multiplier:0.5 constant:1]];
    
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
    
    cell.text = service.name;
    cell.shape = service.theme.shareButtonShape;
    cell.icon = service.serviceImage;
    cell.backgroundColor = [service.backgroundColor
                            colorWithAlphaComponent:service.theme.shareButtonFadeFactors.AlphaUnfadeFactor];
    cell.font = [UIFont fontWithName:service.fontFamily size:14];
    cell.textColor = service.backgroundColor;
    cell.textAlignment = self.theme.shareButtonLabelTextAlignment;
    
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
    CGFloat containerWidth = collectionView.frame.size.width;
    CGFloat horizontalEdgeInset = containerWidth - (3 * cellWidth + 2 * cellSpacing);
    
    return UIEdgeInsetsMake(0 * 0.25, horizontalEdgeInset * 0.4, 0, horizontalEdgeInset * 0.4);
}


#pragma mark - Helpers

// cell tap/selection animations
- (void)fadeCell:(YSGShareSheetServiceCell *)cell forService:(YSGShareService *)service
{
    [UIView animateWithDuration:0.2 animations:^
    {
        cell.backgroundColor = [cell.backgroundColor
                                colorWithAlphaComponent:self.theme.shareButtonFadeFactors.AlphaFadeFactor];
    }];
}

- (void)unfadeCell:(YSGShareSheetServiceCell *)cell forService:(YSGShareService *)service
{
    [UIView animateWithDuration:0.4 animations:^
    {
        cell.backgroundColor = [cell.backgroundColor
                                colorWithAlphaComponent:self.theme.shareButtonFadeFactors.AlphaUnfadeFactor];
    }];
}


@end
