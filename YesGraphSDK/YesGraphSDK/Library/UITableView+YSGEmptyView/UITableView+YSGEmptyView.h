//
//  UITableView+NXEmptyView.h
//  TableWithEmptyView
//
//  Created by Ullrich Schäfer on 21.06.12.
//
//

@import UIKit;

@interface UITableView (YSGEmptyView)

@property (nonatomic, strong) UIView *ysg_emptyView;
@property (nonatomic, assign) BOOL ysg_hideSeparatorLinesWhenShowingEmptyView;

@end

@protocol YSGTableViewmptyViewDataSource <UITableViewDataSource>

@optional
- (BOOL)tableViewShouldBypassEmptyView:(UITableView *)tableView;

@end
