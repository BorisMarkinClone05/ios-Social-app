/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

@interface CLFChatsAdapter : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) void(^didSelectRowBlock)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) void(^commitEditingStyleBlock)(UITableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *inexPath);

- (instancetype)initWithTableView:(UITableView *)tableView
                       chatGroups:(NSArray *)chatGroups;

@end
