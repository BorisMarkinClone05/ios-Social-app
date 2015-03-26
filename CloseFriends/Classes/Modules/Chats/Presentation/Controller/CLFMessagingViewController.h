/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>
#import "CLFMessageType.h"
#import "CLFMessagingDataSource.h"
#import "CLFMessage.h"
#import "CLFMessageCell.h"
#import "XMPP.h"
#import "TURNSocket.h"
#import "AppDelegate.h"

@interface CLFMessagingViewController : UIViewController <CLFMessagingDataSource, UITableViewDataSource>
{
    NSMutableArray	*messages;
    NSMutableArray *turnSockets;
}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSString *detailTitle;

- (void)sendMessage:(id<CLFMessage>)message;
- (void)receiveMessage:(id<CLFMessage>)message;
- (void)refreshMessages;


@end
