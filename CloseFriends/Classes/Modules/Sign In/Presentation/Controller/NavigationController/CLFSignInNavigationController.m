/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFSignInNavigationController.h"

@interface CLFSignInNavigationController ()

@end

@implementation CLFSignInNavigationController

#pragma mark - UINavigationController

- (void)awakeFromNib {
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearanceWhenContainedIn:self.class, nil] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:18.0f]}
                                                                               forState:UIControlStateNormal];
    [self.navigationBar setTitleTextAttributes:@{
            NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:18.0f],
            NSForegroundColorAttributeName : [UIColor whiteColor]
    }];
}

@end