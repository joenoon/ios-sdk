//
//  UITableView+YSGEmptyView.m
//  TableWithEmptyView
//
//  Created by Ullrich Schäfer on 21.06.12.
//
//

@import ObjectiveC.runtime;

#import "UITableView+YSGEmptyView.h"

static const NSString *YSGEmptyViewAssociatedKey = @"YSGEmptyViewAssociatedKey";
static const NSString *YSGEmptyViewHideSeparatorLinesAssociatedKey = @"YSGEmptyViewHideSeparatorLinesAssociatedKey";
static const NSString *YSGEmptyViewPreviousSeparatorStyleAssociatedKey = @"YSGEmptyViewPreviousSeparatorStyleAssociatedKey";


void ysg_swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, newMethod);
    }
}



@interface UITableView (YSGEmptyViewPrivate)

@property (nonatomic, assign) UITableViewCellSeparatorStyle ysg_previousSeparatorStyle;

@end


@implementation UITableView (YSGEmptyView)

#pragma mark Entry

+ (void)load;
{
    Class c = [UITableView class];
    ysg_swizzle(c, @selector(reloadData), @selector(ysg_reloadData));
    ysg_swizzle(c, @selector(layoutSubviews), @selector(ysg_layoutSubviews));
}

#pragma mark Properties

- (BOOL)ysg_hasRowsToDisplay;
{
    NSUInteger numberOfRows = 0;
    
    for (NSInteger sectionIndex = 0; sectionIndex < self.numberOfSections; sectionIndex++)
    {
        numberOfRows += [self numberOfRowsInSection:sectionIndex];
    }
    
    return (numberOfRows > 0);
}

@dynamic ysg_emptyView;

- (UIView *)ysg_emptyView;
{
    return objc_getAssociatedObject(self, &YSGEmptyViewAssociatedKey);
}

- (void)setYsg_emptyView:(UIView *)value;
{
    if (self.ysg_emptyView.superview)
    {
        [self.ysg_emptyView removeFromSuperview];
    }
    
    objc_setAssociatedObject(self, &YSGEmptyViewAssociatedKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self ysg_updateEmptyView];
}

@dynamic ysg_hideSeparatorLinesWhenShowingEmptyView;

- (BOOL)ysg_hideSeparatorLinesWhenShowingEmptyView
{
    NSNumber *hideSeparator = objc_getAssociatedObject(self, &YSGEmptyViewHideSeparatorLinesAssociatedKey);
    return hideSeparator ? [hideSeparator boolValue] : NO;
}

- (void)setYsg_hideSeparatorLinesWhenShowingEmptyView:(BOOL)value
{
    NSNumber *hideSeparator = [NSNumber numberWithBool:value];
    objc_setAssociatedObject(self, &YSGEmptyViewHideSeparatorLinesAssociatedKey, hideSeparator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark Updating

- (void)ysg_updateEmptyView;
{
    UIView *emptyView = self.ysg_emptyView;
    
    if (!emptyView) return;
    
    if (emptyView.superview != self) {
        [self addSubview:emptyView];
    }
    
    // setup empty view frame
    CGRect frame = self.bounds;
    frame.origin = CGPointMake(0, 0);
    frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(CGRectGetHeight(self.tableHeaderView.frame), 0, 0, 0));
    frame.size.height -= self.contentInset.top;
    emptyView.frame = frame;
    emptyView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    // check available data
    BOOL emptyViewShouldBeShown = (self.ysg_hasRowsToDisplay == NO);
    
    // check bypassing
    if (emptyViewShouldBeShown && [self.dataSource respondsToSelector:@selector(tableViewShouldBypassEmptyView:)]) {
        BOOL emptyViewShouldBeBypassed = [(id<YSGTableViewmptyViewDataSource>)self.dataSource tableViewShouldBypassEmptyView:self];
        emptyViewShouldBeShown &= !emptyViewShouldBeBypassed;
    }
    
    // hide tableView separators, if present
    if (self.ysg_hideSeparatorLinesWhenShowingEmptyView) {
        if (emptyViewShouldBeShown) {
            if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
                self.ysg_previousSeparatorStyle = self.separatorStyle;
                self.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
        } else {
            if (self.separatorStyle != self.ysg_previousSeparatorStyle) {
                // we've seen an issue with the separator color not being correct when setting separator style during layoutSubviews
                // that's why we schedule the call on the next runloop cycle
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.separatorStyle = self.ysg_previousSeparatorStyle;
                });
                
            }
        }
    }
    
    // show / hide empty view
    emptyView.hidden = !emptyViewShouldBeShown;
}


#pragma mark Swizzle methods

- (void)ysg_reloadData;
{
    // this calls the original reloadData implementation
    [self ysg_reloadData];
    
    [self ysg_updateEmptyView];
}

- (void)ysg_layoutSubviews;
{
    // this calls the original layoutSubviews implementation
    [self ysg_layoutSubviews];
    
    [self ysg_updateEmptyView];
}

@end


#pragma mark Private
#pragma mark -

@implementation UITableView (YSGEmptyViewPrivate)

@dynamic ysg_previousSeparatorStyle;

- (UITableViewCellSeparatorStyle)YSGEV_previousSeparatorStyle
{
    NSNumber *previousSeparatorStyle = objc_getAssociatedObject(self, &YSGEmptyViewPreviousSeparatorStyleAssociatedKey);
    return previousSeparatorStyle ? [previousSeparatorStyle intValue] : self.separatorStyle;
}

- (void)setYsg_previousSeparatorStyle:(UITableViewCellSeparatorStyle)value
{
    NSNumber *previousSeparatorStyle = [NSNumber numberWithInt:value];
    objc_setAssociatedObject(self, &YSGEmptyViewPreviousSeparatorStyleAssociatedKey, previousSeparatorStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
