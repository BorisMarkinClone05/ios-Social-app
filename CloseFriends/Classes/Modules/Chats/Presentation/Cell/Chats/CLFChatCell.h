/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>

@protocol CLFChatInterface;

@interface CLFChatCell : UITableViewCell

- (void)configureWithChat:(id<CLFChatInterface>)chat;

@end
