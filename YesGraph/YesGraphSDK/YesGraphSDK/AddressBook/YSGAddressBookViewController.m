//
//  YSGAddressBookViewController.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import AddressBook;
@import Contacts;

#import "YesGraph.h"
#import "YSGClient.h"
#import "YSGLogging.h"
#import "YSGAddressBookCell.h"
#import "YSGAddressBookViewController.h"
#import "YSGStyling.h"
#import "YSGTheme.h"
#import "YSGContactList.h"
#import "YSGContactList+Operations.h"
#import "UITableView+YSGEmptyView.h"
#import "YSGOnlineContactSource.h"

CGFloat const YSGSearchBarHeight = 44.0;

static NSString *const YSGAddressBookCellIdentifier = @"YSGAddressBookCellIdentifier";

@interface YSGAddressBookViewController () <UISearchBarDelegate, UISearchResultsUpdating, YSGStyling, UITableViewDataSource, UITableViewDelegate>

//
// UI
//

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UIView *searchContainerView;

@property (nonatomic, strong) UITableView *tableView;

//
// Data
//

@property (nonatomic, copy) NSArray <YSGContact *> *suggestions;

@property (nonatomic, strong) YSGContactList *contactList;

@property (nonatomic, copy) NSDictionary <NSString *, NSArray <YSGContact *> *> *sortedContacts;
/*!
 *  Used to order letters in section title, as NSDictionary is unordered.
 */
@property (nonatomic, copy) NSArray <NSString *> *letters;

/*!
 *  Selected entries
 */
@property (nonatomic, copy) NSMutableSet <YSGContact *> *selectedContacts;

//
// Empty view, when no contacts are available
//

@property (nonatomic, strong) UIView *emptyView;

//
// Search
//

@property (nonatomic, copy) NSArray <YSGContact *> *searchResults;

@end

@implementation YSGAddressBookViewController

#pragma mark - Getters and Setters

- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0) style:UITableViewStylePlain];
        [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        [self.view addSubview:tableView];
        
        id<UILayoutSupport> topGuide = self.topLayoutGuide;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(tableView, topGuide);
        
        if (self.service.allowSearch)
        {
            NSDictionary *searchViews = @{ @"tableView" : tableView, @"searchContainerView" : self.searchContainerView };
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchContainerView]-0-[tableView]-0-|" options:0 metrics:nil views:searchViews]];
        }
        else
        {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-[tableView]-0-|" options:0 metrics:nil views:views]];
        }
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views]];
        
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSMutableSet <YSGContact *> *)selectedContacts
{
    if (!_selectedContacts)
    {
        _selectedContacts = [NSMutableSet set];
    }
    
    return _selectedContacts;
}

- (void)setContactList:(YSGContactList *)contactList
{
    _contactList = contactList;
    
    self.suggestions = (contactList.useSuggestions) ? [contactList suggestedEntriesWithNumberOfSuggestions:self.service.numberOfSuggestions] : nil;

    if (contactList.entries.count)
    {
        NSArray<YSGContact *> *trimmedContacts;

        if (self.suggestions.count)
        {
            trimmedContacts = [contactList.entries subarrayWithRange:NSMakeRange(self.suggestions.count, contactList.entries.count - self.suggestions.count)];
        }
        else
        {
            trimmedContacts = contactList.entries;
        }
        
        self.sortedContacts = [YSGContactList sortedEntriesWithEntries:trimmedContacts];
        self.letters = [self.sortedContacts.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    else
    {
        self.sortedContacts = nil;
        self.letters = nil;
    }
    
    if (self.suggestions.count > 0 && [self.service.contactSource isKindOfClass:[YSGOnlineContactSource class]])
    {
        [((YSGOnlineContactSource *)self.service.contactSource) sendShownSuggestions:self.suggestions];
    }
    
    self.searchResults = nil;
    self.selectedContacts = nil;
    
    [self.tableView reloadData];
    
    [self updateUI];
}

- (NSArray <YSGContact *> *)contactsForSection:(NSInteger)section
{
    if (self.searchResults)
    {
        return self.searchResults;
    }
    
    if (self.suggestions.count && section == 0)
    {
        return self.suggestions;
    }
    
    NSString *identifier = [self tableView:self.tableView titleForHeaderInSection:section];
    
    return self.sortedContacts[identifier];
}

- (YSGContact *)contactForIndexPath:(NSIndexPath *)indexPath
{
    return [self contactsForSection:indexPath.section][indexPath.row];
}

- (UIView *)emptyView
{
    if (!_emptyView)
    {
        _emptyView = [[UIView alloc] init];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_emptyView addSubview:activityIndicator];
        
        [activityIndicator startAnimating];
        
        NSLayoutConstraint *horizontal = [NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_emptyView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint *vertical = [NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_emptyView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        
        [_emptyView addConstraints:@[ horizontal, vertical ]];
    }
    
    return _emptyView;
}

#pragma mark - YSGStyling

- (void)applyTheme:(YSGTheme *)theme
{
    self.searchController.searchBar.tintColor = theme.mainColor;
    self.navigationController.navigationBar.tintColor = theme.mainColor;
    self.view.tintColor = theme.mainColor;
    self.tableView.backgroundColor = theme.shareAddressBookTheme.viewBackground;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Contacts", @"Contacts");
    
    //
    // Add the search
    //
    
    if (self.service.allowSearch)
    {
        [self setupSearch];
    }
    
    [self.tableView registerClass:[YSGAddressBookCell class] forCellReuseIdentifier:YSGAddressBookCellIdentifier];
    
    self.tableView.editing = YES;
    
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.ysg_emptyView = self.emptyView;
    self.tableView.ysg_hideSeparatorLinesWhenShowingEmptyView = YES;
    
    //
    // Add navigation buttons
    //
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTap:)];
    
    UIBarButtonItem *inviteButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Invite", @"Invite") style:UIBarButtonItemStylePlain target:self action:@selector(inviteButtonTap:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = inviteButton;

    //
    // Load contact data
    //
    
    if(self.service && self.service.theme)
    {
        [self applyTheme:self.service.theme];
    }
    else
    {
        [self applyTheme:[YSGTheme new]];
    }
    
    [self.service.contactSource fetchContactListWithCompletion:^(YSGContactList *contactList, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contactList = contactList;
        });
    }];

    [self updateUI];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.searchController.searchBar sizeToFit];
}

- (void)setupSearch
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.searchController.searchBar.showsCancelButton = NO;
    
    UIView *searchContainerView = [[UIView alloc] init];
    [searchContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [searchContainerView addSubview:self.searchController.searchBar];
    
    self.searchContainerView = searchContainerView;
    
    [self.view addSubview:searchContainerView];
    
    NSDictionary* views = @{ @"searchContainerView" : searchContainerView, @"topGuide" : self.topLayoutGuide };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchContainerView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[searchContainerView(44)]" options:0 metrics:nil views:views]];
    
    [searchContainerView addSubview:self.searchController.searchBar];
    
    self.definesPresentationContext = YES;
}

#pragma mark - View Transitions

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [_searchController.searchBar sizeToFit];
    } completion:nil];
}

#pragma mark - Actions

- (void)cancelButtonTap:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)inviteButtonTap:(UIBarButtonItem *)sender
{
    [self.service triggerInviteFlowWithContacts:self.selectedContacts.allObjects];
}

- (void)updateUI
{
    self.navigationItem.rightBarButtonItem.enabled = self.selectedContacts.count > 0;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    
    if (!searchText.length)
    {
        self.searchResults = nil;
        
        [self.tableView reloadData];
        
        return;
    }
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@)", searchText];
    
    self.searchResults = [self.contactList.entries filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchResults = nil;
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchResults = nil;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //
    // Search is handled specifically
    //
    if (self.searchResults)
    {
        return 1;
    }
    
    NSInteger sections = self.sortedContacts.count;
    
    if (self.suggestions.count)
    {
        sections++;
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self contactsForSection:section].count;
}

- (UIView *)cellBackgroundViewForColor:(UIColor *)color
{
    if (!color)
    {
        return nil;
    }
    
    UIView *view = [UIView new];
    view.backgroundColor = color;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSGAddressBookCell * cell = [tableView dequeueReusableCellWithIdentifier:YSGAddressBookCellIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[YSGAddressBookCell alloc] initWithReuseIdentifier:YSGAddressBookCellIdentifier];
    }
    
    //
    // Fill the cell
    //
    
    YSGContact *contact = [self contactForIndexPath:indexPath];
    
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.contactString;
    cell.selected = [self.selectedContacts containsObject:contact];
    
    if (self.service && self.service.theme && self.service.theme.shareAddressBookTheme)
    {
        cell.textLabel.font = [UIFont fontWithName:self.service.theme.fontFamily size:self.service.theme.shareAddressBookTheme.cellFontSize];
        cell.detailTextLabel.font = [UIFont fontWithName:self.service.theme.fontFamily size:self.service.theme.shareAddressBookTheme.cellDetailFontSize];
        cell.backgroundView = [self cellBackgroundViewForColor:self.service.theme.shareAddressBookTheme.cellBackground];
        cell.selectedBackgroundView = [self cellBackgroundViewForColor:self.service.theme.shareAddressBookTheme.cellSelectedBackground];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    
    if ([self.selectedContacts containsObject:contact])
    {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchResults)
    {
        return nil;
    }
    
    if (self.suggestions.count && section == 0)
    {
        return NSLocalizedString(@"Suggestions", @"Suggestions");
    }
    else if (self.suggestions.count)
    {
        return self.letters[section - 1];
    }
    
    return self.letters[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.suggestions.count)
    {
        return [self.letters indexOfObject:title] + 1;
    }
    
    return [self.letters indexOfObject:title];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSGContact *contact = [self contactForIndexPath:indexPath];
    
    [self.selectedContacts addObject:contact];
    
    [self updateUI];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSGContact *contact = [self contactForIndexPath:indexPath];
    
    [self.selectedContacts removeObject:contact];
    
    [self updateUI];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (self.service && self.service.theme && [view isKindOfClass:[UITableViewHeaderFooterView class]])
    {
        __weak UITableViewHeaderFooterView *lbl = (UITableViewHeaderFooterView *)view;
        lbl.textLabel.font = [UIFont fontWithName:self.service.theme.fontFamily size:self.service.theme.shareAddressBookTheme.sectionFontSize];
        
        // TODO: set the height of the section view so it'll be tall enough for
        //       the font height
        
        lbl.backgroundView.backgroundColor = self.service.theme.shareAddressBookTheme.sectionBackground ?: [UIColor clearColor];
    }
}

#pragma mark - Private Methods

@end
