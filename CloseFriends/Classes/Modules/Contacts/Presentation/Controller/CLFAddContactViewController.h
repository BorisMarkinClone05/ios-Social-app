/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>

@interface CLFAddContactViewController : UITableViewController

@property (nonatomic, copy) void(^completionHandler)(NSString *emailOrPhone);

@end
