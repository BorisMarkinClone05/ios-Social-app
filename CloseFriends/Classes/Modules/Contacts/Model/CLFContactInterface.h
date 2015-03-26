/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import Foundation;

typedef NS_ENUM(NSUInteger, CLFContactStatus)
{
    CLFContactStatusAvailable,
    CLFContactStatusAway,
    CLFContactStatusBusy
};

@protocol CLFContactInterface <NSObject>

@property (nonatomic, readonly) NSString *fullName;

@property (nonatomic, readonly) CLFContactStatus status;
@property (nonatomic, readonly) NSString *statusAsString;

@end
