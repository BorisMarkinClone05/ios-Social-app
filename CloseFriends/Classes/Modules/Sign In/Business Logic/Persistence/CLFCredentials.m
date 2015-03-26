/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFCredentials.h"

@implementation CLFCredentials

- (instancetype)copyWithZone:(NSZone *)zone {
    CLFCredentials *credentials = [CLFCredentials new];
    credentials.sessionId = self.sessionId;
    
    return credentials;
}

@end
