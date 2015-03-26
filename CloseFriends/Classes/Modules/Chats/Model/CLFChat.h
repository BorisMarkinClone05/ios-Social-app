/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>
#import "CLFChatInterface.h"

@interface CLFChat : NSObject <CLFChatInterface>

- (instancetype)initWithContact:(id<CLFContactInterface>)contact;

@end
