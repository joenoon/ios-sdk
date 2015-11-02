//
//  YSGAddressBookViewController+ExposedPrivate.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 02/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGAddressBookViewController.h"

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

- (UITableView *)tableView;

- (NSMutableSet <YSGContact *> *)selectedContacts;

- (void)setContactList:(YSGContactList *)contactList;

- (NSArray <YSGContact *> *)contactsForSection:(NSInteger)section;

- (YSGContact *)contactForIndexPath:(NSIndexPath *)indexPath;

- (UIView *)emptyView;

- (void)setupSearch;

- (void)updateUI;

@end
