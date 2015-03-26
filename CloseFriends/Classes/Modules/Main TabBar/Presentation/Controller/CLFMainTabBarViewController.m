/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFMainTabBarViewController.h"

#import "CLFStoryboardProvider.h"
#import "CLFAppearanceManager.h"
#import "CLFDefaultTheme.h"

#import "UIViewController+StatusBarAppearance.h"

@interface CLFMainTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation CLFMainTabBarViewController

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        [self commonInitialization];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    
    return self;
}

- (void)commonInitialization
{
    CLFStoryboardProvider *storyboardProvider = [CLFStoryboardProvider sharedInstance];
    
    self.viewControllers = @[
                             [[storyboardProvider chatsStoryboard] instantiateInitialViewController],
                             [[storyboardProvider contactsStoryboard] instantiateInitialViewController],
                             [[storyboardProvider photosStoryboard] instantiateInitialViewController],
                             [[storyboardProvider profileStoryboard] instantiateInitialViewController]
                             ];
    self.delegate = self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

#pragma mark -

@end
