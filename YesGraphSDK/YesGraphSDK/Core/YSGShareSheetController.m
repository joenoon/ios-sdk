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
#import "YSGDrawableView.h"

NSString *_Nonnull const YSGShareSheetMessageKey = @"YSGShareSheetMessageKey";

static NSString *const YSGShareSheetCellIdentifier = @"YSGShareSheetCellIdentifier";

@interface YSGShareSheetController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) YSGTheme *theme;

@property (nonatomic, copy, readwrite)  NSArray <YSGShareService *> *services;

@property (nonatomic) CGFloat cellWidth;
@property (nonatomic) CGFloat cellHeight;

@end

@implementation YSGShareSheetController

#pragma mark - Getters and Setters

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithServices:@[ ] delegate:nil];;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithServices:@[ ] delegate:nil];
}

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
    
    if ([self isModal])
    {
        // set up if view was prsented modally
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"Close") style:UIBarButtonItemStylePlain target:self action:@selector(modalCloseButtonPressed:)];
        backButton.tintColor = self.theme.baseColor;
        self.navigationItem.leftBarButtonItem = backButton;
    }
    else {
        self.navigationController.navigationBar.tintColor = self.theme.baseColor;
        self.title = @"Share";
    }

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //
    // Setup views
    //
    
    self.cellWidth = self.view.frame.size.width/5;
    self.cellHeight = 75;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.cellWidth, self.cellHeight);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[YSGShareSheetServiceCell class] forCellWithReuseIdentifier:YSGShareSheetCellIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
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
    
    UILabel *shareLabel = [UILabel new];
    
    shareLabel.translatesAutoresizingMaskIntoConstraints = NO;
    shareLabel.text = NSLocalizedString(@"Share this app with friends to get our eternal gratitude", @"");
    shareLabel.font = [UIFont systemFontOfSize:36.f];
    shareLabel.textColor = self.theme.baseColor;
    shareLabel.lineBreakMode = NSLineBreakByWordWrapping;
    shareLabel.numberOfLines = 0;
    shareLabel.textAlignment = NSTextAlignmentCenter;
    [shareLabel sizeToFit];
    
    [self.view addSubview:header];
    [header addSubview:shareLabel];
    [header addSubview:logoView];
    [header addSubview:shareLabel];
    
    UICollectionView *collectionView = self.collectionView;
    [self.view addSubview:self.collectionView];
    
    //
    // Referral link view
    //
    
    UIView* footer = [[UIView alloc] init];
    UILabel *referralLabel = [UILabel new];
    UIButton *copyButton = [UIButton new];
    footer.translatesAutoresizingMaskIntoConstraints = NO;
    referralLabel.translatesAutoresizingMaskIntoConstraints = NO;
    copyButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (self.referralURL.length) {
        
        footer.layer.borderColor = self.theme.baseColor.CGColor;
        footer.layer.borderWidth = 1.5f;
        footer.layer.cornerRadius = 20;
        
        referralLabel.text = self.referralURL;
        referralLabel.textColor = [UIColor blackColor];
        referralLabel.textAlignment = NSTextAlignmentCenter;
        
        [referralLabel sizeToFit];
        
        [copyButton setTitle:NSLocalizedString(@"copy", @"copy") forState:UIControlStateNormal];
        [copyButton addTarget:self action:@selector(copy:) forControlEvents:UIControlEventTouchDown];
        [copyButton setTitleColor:self.theme.baseColor forState:UIControlStateNormal];
        [copyButton setTitleColor:[self.theme.baseColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [copyButton sizeToFit];
        
    }
    
    [self.view addSubview:footer];
    [footer addSubview:referralLabel];
    [footer addSubview:copyButton];
    
    UIView *superview = self.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(superview, header, collectionView, shareLabel, logoView, footer, referralLabel, copyButton);
    
    //
    // Constraints
    //
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[collectionView]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[header]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[footer]-20-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[shareLabel]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[logoView]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[referralLabel]-10-[copyButton]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[header]-10-[collectionView(140)]->=20-[footer(40)]-20-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[shareLabel]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[referralLabel]-0-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[copyButton]-0-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeHeight multiplier:0.5 constant:1]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:referralLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:footer attribute:NSLayoutAttributeWidth multiplier:0.7 constant:1]];
    
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
        cell = [[YSGShareSheetServiceCell alloc] initWithFrame:CGRectMake(0.0, 0.0, self.cellWidth, self.cellHeight)];
    }
    
    YSGDrawableView *draw = [YSGDrawableView new];
    [self.view addSubview:draw];
    
    cell.text = service.name;
    cell.shape = YSGShareSheetServiceCellShapeCircle;
    cell.icon = service.serviceImage;
    cell.serviceColor = service.backgroundColor;
    cell.font = [UIFont fontWithName:service.fontFamily size:14];
    cell.textColor = service.backgroundColor;
    
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
    
    CGFloat cellSpacing = [(UICollectionViewFlowLayout*)collectionViewLayout minimumInteritemSpacing];
    
    // centers cell section in container horizontally
    CGFloat containerWidth = collectionView.frame.size.width;
    
    CGFloat horizontalEdgeInset = containerWidth - (self.services.count * self.cellWidth + (self.services.count-1) * cellSpacing);
    
    return UIEdgeInsetsMake(0, horizontalEdgeInset/2, 0, horizontalEdgeInset/2);
}


#pragma mark - Helpers

// cell tap/selection animations
- (void)fadeCell:(YSGShareSheetServiceCell *)cell forService:(YSGShareService *)service
{
    [UIView animateWithDuration:0.2 animations:^
    {
        cell.backgroundColor = [cell.backgroundColor colorWithAlphaComponent:0.8];
    }];
}

- (void)unfadeCell:(YSGShareSheetServiceCell *)cell forService:(YSGShareService *)service
{
    [UIView animateWithDuration:0.4 animations:^
    {
        cell.backgroundColor = [cell.backgroundColor colorWithAlphaComponent:1.0];
    }];
}

- (void)copy:(id)sender
{
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    NSString *referralString = self.referralURL;
    if (referralString) {
        [gpBoard setString:referralString];
    }
    
    [sender setTitle:@"copied" forState:UIControlStateNormal];
}

// figure out if view was presented modally
- (BOOL)isModal
{
    if([self presentingViewController])
        return YES;
    if([[self presentingViewController] presentedViewController] == self)
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}

-(void)modalCloseButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - View Transitions

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.cellWidth = size.width/5;
    self.cellHeight = 75;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(self.cellWidth, self.cellHeight);
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:flowLayout];
    } completion:nil];
}

@end
