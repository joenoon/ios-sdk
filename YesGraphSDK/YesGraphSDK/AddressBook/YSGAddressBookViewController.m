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
#import "YSGContactManager.h"
#import "YSGAddressBookCell.h"
#import "YSGAddressBookViewController.h"

CGFloat const YSGSearchBarHeight = 44.0;

static NSString *const YSGAddressBookCellIdentifier = @"YSGAddressBookCellIdentifier";

@interface YSGAddressBookViewController () <UISearchBarDelegate, UISearchResultsUpdating>

//
// UI
//

@property (nonatomic, strong) UISearchController *searchController;

//
// Data
//

@property (nonatomic, copy) NSArray <YSGContact *> *suggestions;

@property (nonatomic, copy) NSArray <YSGContact *> *contacts;

@property (nonatomic, copy) NSDictionary <NSString *, NSArray <YSGContact *> *> *sortedContacts;
/*!
 *  Used to order letters in section title, as NSDictionary is unordered.
 */
@property (nonatomic, copy) NSArray <NSString *> *letters;

/*!
 *  Selected contacts
 */
@property (nonatomic, copy) NSMutableSet <YSGContact *> *selectedContacts;

//
// Search
//

@property (nonatomic, copy) NSArray <YSGContact *> *searchResults;

@end

@implementation YSGAddressBookViewController

#pragma mark - Getters and Setters

- (NSMutableSet <YSGContact *> *)selectedContacts
{
    if (!_selectedContacts)
    {
        _selectedContacts = [NSMutableSet set];
    }
    
    return _selectedContacts;
}

- (void)setContacts:(NSArray<YSGContact *> *)contacts
{
    _contacts = contacts;
    
    self.suggestions = [self suggestedContactsWithContacts:contacts];
    
    NSArray<YSGContact *> *trimmedContacts = [contacts subarrayWithRange:NSMakeRange(self.service.numberOfSuggestions, contacts.count - self.service.numberOfSuggestions)];
    
    self.sortedContacts = [self sortedContactsWithContactList:trimmedContacts];
    self.letters = [self.sortedContacts.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.searchResults = nil;
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
        
        self.tableView.tableHeaderView = self.searchController.searchBar;
        
        self.definesPresentationContext = YES;
        
        [self.searchController.searchBar sizeToFit];
        
        self.searchController.searchBar.tintColor = [UIColor redColor];
        self.searchController.searchBar.showsCancelButton = NO;
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.view.tintColor = [UIColor redColor];
    
    
    [self.tableView registerClass:[YSGAddressBookCell class] forCellReuseIdentifier:YSGAddressBookCellIdentifier];
    
    self.tableView.editing = YES;
    
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
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
    
    [self.service.contactManager fetchContactListWithCompletion:^(NSArray<YSGContact *> *contacts, NSError *error) {
        
        self.contacts = contacts;
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark - Actions

- (void)cancelButtonTap:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)inviteButtonTap:(UIBarButtonItem *)sender
{
    if (!self.selectedContacts.count)
    {
        [[[UIAlertView alloc] initWithTitle:@"YesGraph" message:@"Please select at least one contact." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        return;
    }
    
    NSMutableString *message = [[NSMutableString alloc] initWithString:@"Invited: "];
    
    for (YSGContact *contact in self.selectedContacts)
    {
        [message appendString:contact.name];
        [message appendString:@", "];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"YesGraph" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //[self searchBar:searchController.searchBar textDidChange:searchController.searchBar.text];
    
    NSString *searchText = searchController.searchBar.text;
    
    if (!searchText.length)
    {
        self.searchResults = nil;
        
        [self.tableView reloadData];
        
        return;
    }
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@)", searchText];
    
    self.searchResults = [self.contacts filteredArrayUsingPredicate:predicate];
    
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
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSGContact *contact = [self contactForIndexPath:indexPath];
    
    [self.selectedContacts removeObject:contact];
}

#pragma mark - Private Methods

- (NSDictionary <NSString *, NSArray <YSGContact *> *> *)sortedContactsWithContactList:(NSArray <YSGContact *> *)contacts
{
    NSMutableDictionary <NSString *, NSMutableArray <YSGContact *> * > *contactList = [NSMutableDictionary dictionary];
    
    for (YSGContact *contact in contacts)
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
        NSArray *contacts = contactList[letter];
        
        sortedList[letter] = [contacts sortedArrayUsingDescriptors:@[ ascDescriptor ]];
    }
    
    return sortedList.copy;
}

- (NSArray <YSGContact *> *)suggestedContactsWithContacts:(NSArray <YSGContact *> *)contacts
{
    NSMutableArray <YSGContact *> * suggested = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < self.service.numberOfSuggestions; i++)
    {
        if (i < contacts.count)
        {
            [suggested addObject:contacts[i]];
        }
        else
        {
            break;
        }
    }
    
    return suggested.copy;
}

@end
