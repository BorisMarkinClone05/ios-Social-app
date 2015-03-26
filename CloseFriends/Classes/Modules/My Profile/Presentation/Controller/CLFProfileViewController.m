/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFProfileViewController.h"

#import "UIViewController+StatusBarAppearance.h"

@interface CLFProfileViewController ()

@end

@implementation CLFProfileViewController

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        [self commonInitialzation];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialzation];
    }
    
    return self;
}

- (void)commonInitialzation {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"My Profile"
                                                    image:[UIImage imageNamed:@"profileTabIcon"]
                                            selectedImage:[UIImage imageNamed:@"profileTabIconSelected"]];
    self.title = @"My Profile";
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self defaultPreferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    return [self defaultPrefersStatusBarHidden];
}

#pragma mark -

@end
