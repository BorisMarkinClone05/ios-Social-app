/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFAppearanceManager.h"
#import <UIKit/UIKit.h>

#import "CLFMacros.h"
#import "CLFNavigationController.h"
#import "CLFTheme.h"
#import "CLFNavigationBar.h"

@implementation CLFAppearanceManager

#pragma mark - Initialization

+ (instancetype)sharedInstance {
    static CLFAppearanceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        sharedInstance = [CLFAppearanceManager new];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //
    }
    
    return self;
}

#pragma mark - Public methods

- (void)setCurrentTheme:(id<CLFTheme>)currentTheme {
    if (currentTheme != _currentTheme) {
        _currentTheme = currentTheme;
        
        [self configureNavigationBarWithTheme:_currentTheme];
        [self configureTabBarWithTheme:_currentTheme];
        [self configureNavigationBarBarButtonItemWithTheme:_currentTheme];
        [self configureSegmentedControlWithTheme:_currentTheme];
        [self configureCollectionViewWithTheme:_currentTheme];
    }
}

#pragma mark - Private helper methods

- (void)configureNavigationBarWithTheme:(id<CLFTheme>)theme {
    UINavigationBar *appearance = [UINavigationBar appearanceWhenContainedIn:[CLFNavigationController class], nil];
    appearance.tintColor = [theme navigationBarTintColor];
    appearance.barTintColor = [theme navigationBarBarTintColor];
    [appearance setTitleTextAttributes:@{
            NSFontAttributeName : [theme navigationBarTitleFont],
            NSForegroundColorAttributeName : [theme navigationBarTitleColor]
    }];
}

- (void)configureTabBarWithTheme:(id<CLFTheme>)theme {
    UITabBar *appearance = [UITabBar appearance];
    appearance.tintColor = [theme tabBarTintColor];
}

- (void)configureNavigationBarBarButtonItemWithTheme:(id<CLFTheme>)theme {
    UIBarButtonItem *appearance = [UIBarButtonItem appearanceWhenContainedIn:[CLFNavigationController class], nil];
    
    [appearance setTitleTextAttributes:@{
                                         NSFontAttributeName : [theme navigationBarBarButtonItemFont]
                                         }
                              forState:UIControlStateNormal];
}

- (void)configureSegmentedControlWithTheme:(id<CLFTheme>)theme {
    UISegmentedControl *appearance = [UISegmentedControl appearance];
    appearance.tintColor = [theme segmentedControlTintColor];
}

- (void)configureCollectionViewWithTheme:(id <CLFTheme>)theme {
    UICollectionView *appearance = [UICollectionView appearance];
    appearance.backgroundColor = [theme generalBackgroundColor];
}

#pragma mark -

@end
