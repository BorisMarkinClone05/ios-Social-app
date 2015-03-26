/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@protocol CLFContactInterface;

@protocol CLFChatInterface <NSObject>

@property (nonatomic, readonly) id<CLFContactInterface> contact;
@property (nonatomic, readonly) NSString *lastMessage;

@end
