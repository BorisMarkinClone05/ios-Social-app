/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFContactGroup.h"

@interface CLFContactGroup ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSArray *contacts;

@end

@implementation CLFContactGroup

#pragma mark - Initialization

- (instancetype)initWithName:(NSString *)name
                    contacts:(NSArray *)contacts {
    self = [super init];
    if (self) {
        self.name = name;
        self.contacts = contacts;
    }
    return self;
}

#pragma mark - CLFContactGroupInterface

@synthesize name = _name;
@synthesize contacts = _contacts;

#pragma mark -


@end
