/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChat.h"
#import "CLFContactInterface.h"

@interface CLFChat ()

@property (nonatomic, strong, readwrite) id<CLFContactInterface> contact;
@property (nonatomic, strong, readwrite) NSString *lastMessage;

@end

@implementation CLFChat

#pragma mark - Initialization

- (instancetype)initWithContact:(id<CLFContactInterface>)contact
{
    self = [super init];
    
    if (self)
    {
        self.contact = contact;
        self.lastMessage = @"Last Message";
    }
    
    return self;
}

#pragma CLFChatInterface

@synthesize contact = _contact;
@synthesize lastMessage = _lastMessage;

#pragma mark -

@end
