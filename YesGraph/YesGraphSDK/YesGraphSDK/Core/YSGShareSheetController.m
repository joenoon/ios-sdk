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
#import "YSGThemeConstants.h"
#import "YSGClient+Invite.h"
#import "YSGInviteService.h"
#import "YesGraph.h"

NSString *_Nonnull const YSGShareSheetMessageKey = @"YSGShareSheetMessageKey";

static NSString *const YSGShareSheetCellIdentifier = @"YSGShareSheetCellIdentifier";

@interface YSGShareSheetController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, copy, readwrite)  NSArray <YSGShareService *> *services;

@property (nonatomic) CGFloat cellWidth;
@property (nonatomic) CGFloat cellHeight;

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UILabel *referralLabel;
@property (nonatomic, strong) UIButton *cpyButton;


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
        // Set up if view was presented modally
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"Close") style:UIBarButtonItemStylePlain target:self action:@selector(modalCloseButtonPressed:)];
        backButton.tintColor = self.theme.mainColor;
        self.navigationItem.leftBarButtonItem = backButton;
    }
    else
    {
        self.navigationController.navigationBar.tintColor = self.theme.mainColor;
        self.title = NSLocalizedString(@"Share", @"Share");
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //
    // Setup views
    //
    
    self.cellWidth = self.view.frame.size.width/5;
    self.cellHeight = 75;
    
    // HEADER
    self.header = [[UIView alloc] init];
    self.logoView = [UIImageView new];
    self.shareLabel = [UILabel new];
    [self setupHeader];
    
    // SHARE SERVICES
    [self setupShareServicesView];
    
    // FOOTER
    
    self.footer = [[UIView alloc] init];
    self.referralLabel = [UILabel new];
    self.cpyButton = [UIButton new];
    [self setupFooter];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.footer];
    [self.footer addSubview:self.referralLabel];
    [self.footer addSubview:self.cpyButton];
    
    // AUTO LAYOUT CONSTRAINTS
    [self setupConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)setupHeader
{
    //
    // Header container view - logo + text
    //
    
    self.header.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    //  Company logo view
    
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    //
    // Share text view
    
    self.shareLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.shareLabel.text = NSLocalizedString(@"Share this app with friends to get our eternal gratitude", @"");
    self.shareLabel.font = [UIFont systemFontOfSize:36.f];
    self.shareLabel.textColor = self.theme.baseColor;
    self.shareLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.shareLabel.numberOfLines = 0;
    self.shareLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareLabel sizeToFit];
    
    [self.view addSubview:self.header];
    [self.header addSubview:self.shareLabel];
    [self.header addSubview:self.logoView];
    [self.header addSubview:self.shareLabel];
}

- (void)setupShareServicesView
{
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
    
}

- (void)setupFooter
{
    //
    // Referral link view
    //
    
    self.footer.translatesAutoresizingMaskIntoConstraints = NO;
    self.referralLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.cpyButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (self.referralURL.length)
    {
        
        self.footer.layer.borderColor = self.theme.baseColor.CGColor;
        self.footer.layer.borderWidth = 1.5f;
        self.footer.layer.cornerRadius = 20;
        
        self.referralLabel.text = self.referralURL;
        self.referralLabel.textColor = [UIColor blackColor];
        self.referralLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.referralLabel sizeToFit];
        
        [self.cpyButton setTitle:NSLocalizedString(@"copy", @"copy") forState:UIControlStateNormal];
        [self.cpyButton addTarget:self action:@selector(copy:) forControlEvents:UIControlEventTouchDown];
        
        [self.cpyButton setTitleColor:[YSGThemeConstants defaultMainColor] forState:UIControlStateNormal];
        [self.cpyButton setTitleColor:[self.theme.baseColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [self.cpyButton sizeToFit];
    }
}

- (void)setupConstraints
{
    UIView *superview = self.view;
    
    NSDictionary *views = @{
                            @"superview": superview,
                            @"header": self.header,
                            @"collectionView": self.collectionView,
                            @"shareLabel": self.shareLabel,
                            @"logoView": self.logoView,
                            @"footer": self.footer,
                            @"referralLabel": self.referralLabel,
                            @"cpyButton": self.cpyButton
                            };
    
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
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[referralLabel]-10-[cpyButton(60)]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontalConstraints];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[header]->=10-[collectionView(140)]-10-[footer(40)]-20-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[shareLabel]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[referralLabel]-0-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[cpyButton]-0-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.header attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeHeight multiplier:0.5 constant:1]];
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

- (void)copy:(UIButton *)sender
{
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    NSString *referralString = self.referralURL;
    
    if (referralString)
    {
        [gpBoard setString:referralString];
    }
    
    [sender setTitle:@"copied" forState:UIControlStateNormal];
}

- (BOOL)isModal
{
    if ([self presentingViewController])
    {
        return YES;
    }
    
    if ([[self presentingViewController] presentedViewController] == self)
    {
        return YES;
    }
    
    if ([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
    {
        return YES;
    }
    
    if ([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
    {
        return YES;
    }
    
    return NO;
}

- (void)modalCloseButtonPressed:(UIButton *)sender
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
