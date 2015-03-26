/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import UIKit;

@class CLFPhoneNumber;

@interface CLFSignInPhoneCell : UITableViewCell

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *phone;

- (void)configureCellWithPhoneNumber:(CLFPhoneNumber *)phoneNumber andCodeСhangesHandler:(void(^)(NSString *code))handler;

@end