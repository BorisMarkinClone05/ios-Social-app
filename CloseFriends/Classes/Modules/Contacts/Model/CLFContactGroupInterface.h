/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@protocol CLFContactGroupInterface <NSObject>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray *contacts;

@end
