/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

#import "CLFContactsSectionHeaderView.h"

@interface CLFContactsAdapter : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<CLFContactsSectionHeaderViewDelegate> sectionHeaderDelegate;
@property (nonatomic, copy) void(^didSelectRowBlock)(UITableView *tableView, NSIndexPath *indexPath);

- (instancetype)initWithTableView:(UITableView *)tableView
                    contactGroups:(NSArray *)contactGroups;

@end

