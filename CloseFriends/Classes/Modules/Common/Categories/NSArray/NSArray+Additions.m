/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (id)nextObjectForObject:(id)obj {
    id next = nil;
    
    if (obj && self.count > 1) {
        NSUInteger idx = [self indexOfObject:obj];
        if (idx != NSNotFound && idx < self.count - 1) {
            next = self[idx+1];
        }
    }
    
    return next;
}

- (id)previousObjectForObject:(id)obj {
    id prev = nil;
    
    if (obj && self.count > 1) {
        NSUInteger idx = [self indexOfObject:obj];
        if (idx != NSNotFound && idx != 0) {
            prev = self[idx-1];
        }
    }
    
    return prev;
}

@end
