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

@interface YSGAddressBookViewController () <UISearchBarDelegate>

//
// UI
//

@property (nonatomic, strong) UISearchBar *searchBar;

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

//
// Search
//

@property (nonatomic, copy) NSArray <YSGContact *> *searchResults;

@end

@implementation YSGAddressBookViewController

#pragma mark - Getters and Setters

- (void)setContacts:(NSArray<YSGContact *> *)contacts
{
    _contacts = contacts;
    
    self.suggestions = [self suggestedContactsWithContacts:contacts];
    self.sortedContacts = [self sortedContactsWithContactList:contacts];
    self.letters = [self.sortedContacts.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.searchResults = nil;
}

- (NSArray <YSGContact *> *)contactsForSection:(NSInteger)section
{
    if (self.suggestions.count && section == 0)
    {
        return self.suggestions;
    }
    else if (self.suggestions.count)
    {
        NSString *identifier = [self tableView:self.tableView titleForHeaderInSection:section - 1];
        
        return self.sortedContacts[identifier];
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
        self.searchBar = [[UISearchBar alloc] init];
        
        self.searchBar.delegate = self;
        
        //self.tableView.tableHeaderView = self.searchBar;
    }
    
    [self.tableView registerClass:[YSGAddressBookCell class] forCellReuseIdentifier:YSGAddressBookCellIdentifier];
    
    self.tableView.editing = YES;
    
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
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
    
    self.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, YSGSearchBarHeight);
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // Clean table
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.suggestions.count && section == 0)
    {
        return @"Suggestions";
    }
    else if (self.suggestions.count)
    {
        return self.letters[section - 1];
        
        //return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section - 1];
    }
    
    return self.letters[section];
    
    //return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.suggestions.count)
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index + 1];
    }
    
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
