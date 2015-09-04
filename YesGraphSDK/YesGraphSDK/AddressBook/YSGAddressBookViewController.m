//
//  YSGAddressBookViewController.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import AddressBook;
@import Contacts;

#import "YSGClient.h"
#import "YSGAddressBookCell.h"
#import "YSGAddressBookViewController.h"
#import "YSGStyling.h"
#import "YSGTheme.h"
#import "YSGContactList.h"
#import "UITableView+YSGEmptyView.h"

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
    
    self.suggestions = (contactList.useSuggestions) ? [self suggestedContactsWithContacts:contactList.entries] : nil;
    
    if (contactList.entries.count)
    {
        NSArray<YSGContact *> *trimmedContacts = [contactList.entries subarrayWithRange:NSMakeRange(self.service.numberOfSuggestions, contactList.entries.count - self.service.numberOfSuggestions)];
        
        self.sortedContacts = [self sortedContactsWithContactList:trimmedContacts];
        self.letters = [self.sortedContacts.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    else
    {
        self.sortedContacts = nil;
        self.letters = nil;
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
    self.searchController.searchBar.tintColor = [UIColor redColor];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.view.tintColor = [UIColor redColor];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Contacts";
    
    //
    // Add the search
    //
    
    if (self.service.allowSearch)
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
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTap:)];
    
    UIBarButtonItem *inviteButton = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStylePlain target:self action:@selector(inviteButtonTap:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = inviteButton;

    //
    // Load contact data
    //
    
    [self applyTheme:[YSGTheme new]];
    
    [self.service.contactSource fetchContactListWithCompletion:^(YSGContactList *contactList, NSError *error)
    {
        self.contactList = contactList;
    }];
    
    [self updateUI];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.searchController.searchBar sizeToFit];
}

#pragma mark - Actions

- (void)cancelButtonTap:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)inviteButtonTap:(UIBarButtonItem *)sender
{
    [self.service triggerInviteFlowWithContacts:self.selectedContacts.allObjects];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
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
        return @"Suggestions";
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

#pragma mark - Private Methods

- (NSDictionary <NSString *, NSArray <YSGContact *> *> *)sortedContactsWithContactList:(NSArray <YSGContact *> *) entries
{
    NSMutableDictionary <NSString *, NSMutableArray <YSGContact *> * > *contactList = [NSMutableDictionary dictionary];
    
    for (YSGContact *contact in entries
            )
    {
        NSString *letter = [contact.name substringToIndex:1];
        
        if (!contactList[letter])
        {
            contactList[letter] = [NSMutableArray array];
        }
        
        [contactList[letter] addObject:contact];
    }
    
    NSSortDescriptor *ascDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    NSMutableDictionary <NSString *, NSArray <YSGContact *> * > *sortedList = [NSMutableDictionary dictionary];
    
    for (NSString* letter in contactList)
    {
        NSArray *sortedContacts = contactList[letter];
        
        sortedList[letter] = [sortedContacts sortedArrayUsingDescriptors:@[ ascDescriptor ]];
    }
    
    return sortedList.copy;
}

- (NSArray <YSGContact *> *)suggestedContactsWithContacts:(NSArray <YSGContact *> *) entries
{
    NSMutableArray <YSGContact *> * suggested = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < self.service.numberOfSuggestions; i++)
    {
        if (i < entries.count)
        {
            [suggested addObject:entries[i]];
        }
        else
        {
            break;
        }
    }
    
    return suggested.copy;
}

@end
