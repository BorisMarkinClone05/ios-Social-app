/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChatGroup.h"

@interface CLFChatGroup ()

@property (nonatomic, strong, readwrite) NSArray *chats;
@property (nonatomic, copy, readwrite) NSString *title;

@end

@implementation CLFChatGroup

#pragma mark - Initialization

- (instancetype)initWithChats:(NSArray *)chats title:(NSString *)title
{
    self = [super init];
    
    if (self)
    {
        self.chats = chats;
        self.title = title;
    }
    
    return self;
}

#pragma mark - CLFChatGroupInterface

@synthesize chats = _chats;
@synthesize title = _title;

#pragma mark -

@end
