/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFDefaultTheme.h"
#import "CLFMacros.h"

@implementation CLFDefaultTheme

#pragma mark - CLFTheme

- (UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

- (UIColor *)navigationBarBarTintColor {
    return UIColorFromRGB(0x00AAE7);
}

- (UIColor *)navigationBarTitleColor {
    return UIColorFromRGB(0xFFFFFF);
}

- (UIFont *)navigationBarTitleFont {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:15.0f];
}

- (UIColor *)tabBarTintColor {
    return UIColorFromRGB(0x00AAE7);
}

- (UIFont *)navigationBarBarButtonItemFont {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:17.0];
}

- (UIColor *)generalBackgroundColor {
    return UIColorFromRGB(0xEFEFF4);
}

- (UIColor *)segmentedControlTintColor {
    return [UIColor whiteColor];
}

#pragma mark -

@end
