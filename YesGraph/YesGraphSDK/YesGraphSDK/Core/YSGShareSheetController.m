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

NSString *_Nonnull const YSGShareSheetSubjectKey = @"YSGShareSheetSubjectKey";
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
- (NSString *)shareText
{
    if (!_shareText)
    {
        return NSLocalizedString(@"Share this app with friends to get our eternal gratitude", @"");
    }
    return _shareText;
}

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
    
    //
    // Setup views
    //
    
    self.cellWidth = self.view.frame.size.width / 5;
    self.cellHeight = 100;
    
    
    // SHARE SERVICES
    [self setupShareServicesView];
    
    // HEADER
    
    [self setupHeader];
    
    
    // FOOTER
    

    [self setupFooter];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.footer];
    [self.footer addSubview:self.referralLabel];
    [self.footer addSubview:self.cpyButton];
    
    // AUTO LAYOUT CONSTRAINTS
    [self setupConstraints];
    
    [self.view layoutIfNeeded];
    
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)setupHeader
{
    self.header = [[UIView alloc] init];
    self.logoView = [UIImageView new];
    self.shareLabel = [UILabel new];
    
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
    self.shareLabel.text = self.shareText;
    self.shareLabel.font = [UIFont fontWithName:self.theme.fontFamily size:self.theme.shareLabelFontSize];
    self.shareLabel.adjustsFontSizeToFitWidth = YES;
    
    self.shareLabel.textColor = self.theme.textColor;
    self.shareLabel.lineBreakMode = NSLineBreakByClipping;
    self.shareLabel.numberOfLines = 0;
    self.shareLabel.textAlignment = self.theme.shareLabelTextAlignment;
    [self.shareLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.shareLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.shareLabel sizeToFit];
    
    [self.view addSubview:self.header];
    [self.header addSubview:self.shareLabel];
    [self.header addSubview:self.logoView];
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
    self.footer = [[UIView alloc] init];
    self.referralLabel = [UILabel new];
    self.cpyButton = [UIButton new];
    
    //
    // Referral link view
    //
    
    self.footer.translatesAutoresizingMaskIntoConstraints = NO;
    self.referralLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.cpyButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (self.referralURL.length)
    {
        self.footer.layer.borderColor = self.theme.mainColor.CGColor;
        self.footer.layer.borderWidth = 1.5f;
        self.footer.layer.cornerRadius = 20;
        self.footer.backgroundColor = self.theme.referralBannerColor;
        
        self.referralLabel.text = self.referralURL;
        self.referralLabel.textColor = self.theme.referralTextColor;
        self.referralLabel.textAlignment = NSTextAlignmentCenter;
        self.referralLabel.font = [UIFont fontWithName:self.theme.fontFamily size:14];
        
        [self.referralLabel sizeToFit];
        
        [self.cpyButton setTitle:NSLocalizedString(@"copy", @"copy") forState:UIControlStateNormal];
        [self.cpyButton addTarget:self action:@selector(copy:) forControlEvents:UIControlEventTouchDown];
        
        [self.cpyButton setTitleColor:self.theme.referralButtonColor forState:UIControlStateNormal];
        [self.cpyButton setTitleColor:[self.theme.referralButtonColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        self.cpyButton.titleLabel.font = [UIFont fontWithName:self.theme.buttonFontFamily size:14];
        [self.cpyButton sizeToFit];
    }
}

- (void)setupConstraints
{
    UIView *superview = self.view;
    
    NSDictionary *views = @{
        @"superview": superview,
        @"topGuide": self.topLayoutGuide,
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
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-10-[header(>=70,<=300)]-10-[collectionView(>=120)]-10-[footer(40)]-20-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[shareLabel]-10-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[referralLabel]-0-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[cpyButton]-0-|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:verticalConstraints];
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
    cell.shape = service.shape;
    cell.icon = service.serviceImage;
    cell.serviceColor = service.backgroundColor;
    cell.font = [UIFont fontWithName:service.fontFamily size:14];
    cell.textColor = service.textColor;
    
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

    CGFloat verticalEdgeInset = (collectionView.frame.size.height / 2) - (self.cellHeight / 2);
    CGFloat horizontalEdgeInset = (containerWidth - (self.services.count * self.cellWidth + (self.services.count-1) * cellSpacing)) / 2;
    
    return UIEdgeInsetsMake(verticalEdgeInset, horizontalEdgeInset, verticalEdgeInset, horizontalEdgeInset);
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
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(self.cellWidth, self.cellHeight);
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:flowLayout];
    } completion:nil];
}

@end
