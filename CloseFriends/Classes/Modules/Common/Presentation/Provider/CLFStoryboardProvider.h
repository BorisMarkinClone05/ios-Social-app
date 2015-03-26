/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CLFStoryboardProvider : NSObject

+ (instancetype)sharedInstance;

- (UIStoryboard *)mainStoryboard;
- (UIStoryboard *)signupStoryboard;
- (UIStoryboard *)countryListStoryboard;
- (UIStoryboard *)chatsStoryboard;
- (UIStoryboard *)contactsStoryboard;
- (UIStoryboard *)photosStoryboard;
- (UIStoryboard *)profileStoryboard;

@end
