/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFAuthService.h"
#import "CLFMainTransport.h"

@interface CLFAuthService ()

@property (nonatomic, strong) CLFMainTransport *transport;

@end

@implementation CLFAuthService

#pragma mark - Initialization

+ (instancetype)authServiceWithTransport:(CLFMainTransport *)transport {
    return [[self alloc] initWithTransport:transport];
}

- (instancetype)initWithTransport:(CLFMainTransport *)transport {
    self = [super init];
    if (self) {
        self.transport = transport;
    }
    
    return self;
}

#pragma mark - Public methods

- (void)signinWithPhoneNumber:(NSString *)phone
                   completion:(void (^)(BOOL, NSError *))completion {
    NSParameterAssert(completion);
    
    
}

@end
