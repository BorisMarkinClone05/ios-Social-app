/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import Foundation;

#import "CLFContactGroupInterface.h"

@interface CLFContactGroup : NSObject <CLFContactGroupInterface>

- (instancetype)initWithName:(NSString *)name
                    contacts:(NSArray *)contacts;

@end
