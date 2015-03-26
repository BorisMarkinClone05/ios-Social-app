/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import Foundation;

#import "CLFContactInterface.h"

@interface CLFContact : NSObject <CLFContactInterface>

- (instancetype)initWithFullName:(NSString *)fullName;

@end
