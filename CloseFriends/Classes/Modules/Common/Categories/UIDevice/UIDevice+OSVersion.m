/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "UIDevice+OSVersion.h"

@implementation UIDevice (OSVersion)

+ (BOOL)isiOS8AndEarlier {
    return NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1;
}

@end
