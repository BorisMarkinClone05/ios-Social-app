/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>
#import "CLFChatGroupInterface.h"

@interface CLFChatGroup : NSObject <CLFChatGroupInterface>

- (instancetype)initWithChats:(NSArray *)chats
                        title:(NSString *)title;

@end
