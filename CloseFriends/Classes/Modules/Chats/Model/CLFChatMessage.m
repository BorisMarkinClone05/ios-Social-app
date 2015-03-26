/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChatMessage.h"

@implementation CLFChatMessage
@synthesize attributes, text, date, fromMe, media, thumbnail, type;

- (id)init
{
    if (self = [super init])
    {
        self.date = [NSDate date];
    }
    
    return self;
}

@end
