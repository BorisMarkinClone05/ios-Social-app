/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFStoryboardProvider.h"

@implementation CLFStoryboardProvider

#pragma mark - Initialization

+ (instancetype)sharedInstance {
    static CLFStoryboardProvider *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^ {
        _sharedInstance = [CLFStoryboardProvider new];
    });
    
    return _sharedInstance;
}

#pragma mark - Public methods

- (UIStoryboard *)mainStoryboard {
    return [UIStoryboard storyboardWithName:@"Main"
                                     bundle:nil];
}

- (UIStoryboard *)signupStoryboard {
    return [UIStoryboard storyboardWithName:@"SignIn"
                                     bundle:nil];
}

- (UIStoryboard *)countryListStoryboard {
    return [UIStoryboard storyboardWithName:@"CountryList"
                                     bundle:nil];
}

- (UIStoryboard *)chatsStoryboard {
    return [UIStoryboard storyboardWithName:@"Chats"
                                     bundle:nil];
}

- (UIStoryboard *)contactsStoryboard {
    return [UIStoryboard storyboardWithName:@"Contacts"
                                     bundle:nil];
}

- (UIStoryboard *)photosStoryboard {
    return [UIStoryboard storyboardWithName:@"Photos"
                                     bundle:nil];
}

- (UIStoryboard *)profileStoryboard {
    return [UIStoryboard storyboardWithName:@"Profile"
                                     bundle:nil];
}

#pragma mark -

@end
