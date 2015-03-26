/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>

@protocol CLFChatGroupInterface;

@interface CLFChatsSectionHeaderView : UITableViewHeaderFooterView

- (void)configureWithChatGroup:(id<CLFChatGroupInterface>)chatGroup;

@end
