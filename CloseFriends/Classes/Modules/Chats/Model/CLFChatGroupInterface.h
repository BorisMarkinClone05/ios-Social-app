/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@protocol CLFChatGroupInterface <NSObject>

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSArray *chats;

@end