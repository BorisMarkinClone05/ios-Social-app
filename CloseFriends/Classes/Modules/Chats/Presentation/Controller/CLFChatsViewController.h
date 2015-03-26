/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

#import "CLFBaseViewController.h"

#import "XMPP.h"
#import "XMPPRoster.h"
#import "XMPPFramework.h"
#import "DDLog.h"

#import "AFNetworking.h"

#import "AppDelegate.h"


@interface CLFChatsViewController : CLFBaseViewController<NSFetchedResultsControllerDelegate>
{
    NSMutableArray *onlineBuddies;
    
    NSFetchedResultsController *fetchedResultsController;
}

@end
