/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import Foundation;

@class CLFCountry;

@interface CLFPhoneNumber : NSObject

@property (nonatomic, readonly) NSString *dialCode;
@property (nonatomic, readonly) NSString *phoneNumber;

- (instancetype)initWithCountry:(CLFCountry *)country;

- (void)updatePhoneNumber:(NSString *)phoneNumber;
- (void)updateCodeFromCountry:(CLFCountry *)country;

- (NSString *)formattedNumber;
- (NSString *)formattedNumberWithDialCode;

@end