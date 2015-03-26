/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>

@class CLFMainTransport;

@interface CLFAuthService : NSObject

@property (nonatomic, readonly) NSString *sessionId;

+ (instancetype)authServiceWithTransport:(CLFMainTransport *)transport;

- (void)signinWithPhoneNumber:(NSString *)phone
                   completion:(void (^)(BOOL success, NSError *error))completion;

@end
