/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>

@interface UIViewController (StatusBarAppearance)

- (UIStatusBarStyle)defaultPreferredStatusBarStyle;
- (UIStatusBarStyle)blackStatusBarStyle;
- (BOOL)defaultPrefersStatusBarHidden;

@end
