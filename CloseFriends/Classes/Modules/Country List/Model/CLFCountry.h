/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>

@interface CLFCountry : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *code;
@property (nonatomic, readonly) NSString *dialCode;

+ (instancetype)countryWithName:(NSString *)name
                           code:(NSString *)code
                       dialCode:(NSString *)dialCode;

@end
