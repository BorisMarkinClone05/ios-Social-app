/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFCountry.h"

@implementation CLFCountry

#pragma mark - Initialization

+ (instancetype)countryWithName:(NSString *)name
                           code:(NSString *)code
                       dialCode:(NSString *)dialCode {
    return [[self alloc] initWithName:name
                                 code:code
                             dialCode:dialCode];
}

- (instancetype)initWithName:(NSString *)name
                        code:(NSString *)code
                    dialCode:(NSString *)dialCode {
    self = [super init];
    if (self) {
        _name = [name copy];
        _code = [code copy];
        _dialCode = [dialCode copy];
    }
    
    return self;
}

@end
