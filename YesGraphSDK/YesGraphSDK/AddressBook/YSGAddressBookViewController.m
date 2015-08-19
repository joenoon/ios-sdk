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

@interface YSGAddressBookViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray <YSGContact *> *suggestions;
@property (nonatomic, copy) NSArray <YSGContact *> *contacts;

@end

@implementation YSGAddressBookViewController

#pragma mark - Getters and Setters

- (NSArray *)contactsForSection:(NSInteger)section
{
    if (self.suggestions.count && section == 0)
    {
        return self.suggestions;
    }
    
    return self.contacts;
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
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.suggestions.count)
    {
        return 2;
    }
    
    return 1;
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
