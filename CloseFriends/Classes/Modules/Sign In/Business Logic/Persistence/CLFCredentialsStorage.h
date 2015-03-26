/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>

@class CLFCredentials;

@interface CLFCredentialsStorage : NSObject

- (CLFCredentials *)storedCredentials;
- (BOOL)storeCredentials:(CLFCredentials *)credentials;
- (BOOL)removeStoredCredentials;

@end
