/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>

@interface CLFContentManager : NSObject

+ (CLFContentManager *)sharedManager;

- (NSArray *)generateConversation;

@end
