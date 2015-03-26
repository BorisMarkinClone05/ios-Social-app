/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFPhoneNumber.h"
#import "NBAsYouTypeFormatter.h"
#import "CLFCountry.h"

@interface CLFPhoneNumber ()

@property (nonatomic, strong) NBAsYouTypeFormatter *formatter;

@end

@implementation CLFPhoneNumber

#pragma mark - Initialization
- (instancetype)initWithCountry:(CLFCountry *)country {
    if (self = [super init]) {
        _formatter = [[NBAsYouTypeFormatter alloc] initWithRegionCode:country.code];
        _dialCode = country.dialCode;
    }
    return self;
}

#pragma mark - Public methods
- (void)updatePhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
}

- (void)updateCodeFromCountry:(CLFCountry *)country {
    _dialCode = country.dialCode;
    _formatter = [[NBAsYouTypeFormatter alloc] initWithRegionCode:country.code];
}

- (NSString *)formattedNumber {
    return [_formatter inputString:_phoneNumber];
}

- (NSString *)formattedNumberWithDialCode {
    return [NSString stringWithFormat:@"%@ %@", _dialCode, [self formattedNumber]];
}
@end