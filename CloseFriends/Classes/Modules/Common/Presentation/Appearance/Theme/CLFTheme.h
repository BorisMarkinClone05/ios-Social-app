/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

@protocol CLFTheme <NSObject>

- (UIColor *)navigationBarTintColor;
- (UIColor *)navigationBarBarTintColor;
- (UIColor *)navigationBarTitleColor;
- (UIFont *)navigationBarTitleFont;
- (UIColor *)tabBarTintColor;

- (UIFont *)navigationBarBarButtonItemFont;

- (UIColor *)generalBackgroundColor;

- (UIColor *)segmentedControlTintColor;
@end
