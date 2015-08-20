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

@property (nonatomic, copy) NSArray <NSArray <YSGContact *> *> *sortedContacts;

@end

@implementation YSGAddressBookViewController

#pragma mark - Getters and Setters

- (NSArray *)contactsForSection:(NSInteger)section
{
    if (self.suggestions.count && section == 0)
    {
        return self.suggestions;
    }
    else if (self.suggestions.count)
    {
        return self.sortedContacts[section - 1];
    }
    
    return self.sortedContacts[section];
}

- (YSGContact *)contactForIndexPath:(NSIndexPath *)indexPath
{
    return [self contactsForSection:indexPath.section][indexPath.row];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // Add the search
    //
    
    if (self.service.allowSearch)
    {
        self.searchBar = [[UISearchBar alloc] init];
        
        self.searchBar.delegate = self;
        
        self.tableView.tableHeaderView = self.searchBar;
    }
    
    self.tableView.editing = YES;
    
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    //
    // Load contact data
    //
    
    [self.service.contactManager fetchContactListWithCompletion:^(NSArray<YSGContact *> *contacts) {
        
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, YSGSearchBarHeight);
}

#pragma mark - UISearchBarDelegate

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
    static NSString *cellIdentifier = @"AddressBookCell";
    
    YSGAddressBookCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[YSGAddressBookCell alloc] initWithReuseIdentifier:cellIdentifier];
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
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Private Methods

- (NSArray <NSArray <YSGContact *> *> *)sortedContactsWithContactList:(NSArray <YSGContact *> *)contacts
{
    
}

@end
