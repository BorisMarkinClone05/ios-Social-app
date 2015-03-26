/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFContact.h"

@interface CLFContact ()

@property (nonatomic, copy, readwrite) NSString *fullName;
@property (nonatomic, assign, readwrite) CLFContactStatus status;

@end

@implementation CLFContact

#pragma mark - Initialization

- (instancetype)initWithFullName:(NSString *)fullName {
    self = [super init];
    if (self) {
        self.fullName = fullName;
        self.status = random() % 3;
    }
    return self;
}

#pragma mark - CLFContactInterface

@synthesize fullName = _fullName;
@synthesize status = _status;

- (NSString *)statusAsString {
    NSString *result = nil;
    
    switch (self.status)
    {
        case CLFContactStatusAvailable:
            result = @"I'm Available";
            break;
        
        case CLFContactStatusAway:
            result = @"Away";
            break;
            
        case CLFContactStatusBusy:
            result = @"Busy";
            break;
            
        default:
            break;
    }
    
    return result;
}

#pragma mark -

@end
