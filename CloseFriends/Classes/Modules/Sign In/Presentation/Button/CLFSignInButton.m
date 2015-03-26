/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFSignInButton.h"

@interface CLFSignInButton ()

@end

@implementation CLFSignInButton

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = 23.0f;
    }
    return self;
}

@end