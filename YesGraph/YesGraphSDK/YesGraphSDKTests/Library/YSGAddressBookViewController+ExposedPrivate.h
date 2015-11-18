//
//  YSGAddressBookViewController+ExposedPrivate.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 02/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGAddressBookViewController.h"

@class UISearchController;

@interface YSGAddressBookViewController (ExposedPrivate)

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UIView *searchContainerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray <YSGContact *> *suggestions;

@property (nonatomic, strong) YSGContactList *contactList;

@property (nonatomic, copy) NSDictionary <NSString *, NSArray <YSGContact *> *> *sortedContacts;

@property (nonatomic, copy) NSArray <NSString *> *letters;

@property (nonatomic, copy) NSMutableSet <YSGContact *> *selectedContacts;

@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, copy) NSArray <YSGContact *> *searchResults;


@end

@interface YSGAddressBookViewController ()

- (UITableView *)tableView;

- (NSMutableSet <YSGContact *> *)selectedContacts;

- (void)setContactList:(YSGContactList *)contactList;

- (NSArray <YSGContact *> *)contactsForSection:(NSInteger)section;

- (YSGContact *)contactForIndexPath:(NSIndexPath *)indexPath;

- (UIView *)emptyView;

- (void)setupSearch;

- (void)updateUI;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;

extern NSInteger contactLettersSort(NSString *letter1, NSString *letter2, void *context);

@end
