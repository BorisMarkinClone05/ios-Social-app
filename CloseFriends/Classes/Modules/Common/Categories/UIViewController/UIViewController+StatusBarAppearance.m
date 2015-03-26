/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "UIViewController+StatusBarAppearance.h"

@implementation UIViewController (StatusBarAppearance)

- (UIStatusBarStyle)defaultPreferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarStyle)blackStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)defaultPrefersStatusBarHidden {
    return NO;
}

@end
