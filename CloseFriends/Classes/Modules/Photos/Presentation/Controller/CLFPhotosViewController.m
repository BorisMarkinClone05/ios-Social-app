/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFPhotosViewController.h"

#import "UIViewController+StatusBarAppearance.h"
#import "UINavigationBar+Hairline.h"
#import "CLFAlbum.h"
#import "CLFPhotoItem.h"
#import "CLFMyPhotosViewController.h"
#import "CLFSharedPhotosViewController.h"
#import "CLFVideoItem.h"

@interface CLFPhotosViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *topViewToolbar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) NSArray *myPhotosSections;
@property (nonatomic, strong) NSArray *sharedAlbums;

@property (nonatomic, strong) CLFMyPhotosViewController *myPhotosVC;
@property (nonatomic, strong) CLFSharedPhotosViewController *sharedPhotosVC;

@property (nonatomic, strong) UIBarButtonItem *editPhotosBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *addNewPhotoBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;

@end

@implementation CLFPhotosViewController

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

- (void)commonInitialization {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Photos"
                                                    image:[UIImage imageNamed:@"photosTabIcon"]
                                            selectedImage:[UIImage imageNamed:@"photosTabIconSelected"]];
    [self updateTitleForEditing:NO];

    [self configureBarItems];

    CLFAlbum *firstAlbum = [[CLFAlbum alloc] initWithName:@"TRIP TO PARIS"];
    CLFPhotoItem *photoItem1 = [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"first_album_background"]];
    [firstAlbum addPhotos:@[photoItem1, [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"760333pic"]], [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"Beach-Landscape-Photography"]], [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"sign_up_screen"]], [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]], [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]], [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]], [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]], [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]]]];

    CLFAlbum *secondAlbum = [[CLFAlbum alloc] initWithName:@"SUMMER 2014"];
    CLFPhotoItem *photoItem2 = [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"second_album_background"]];
    [secondAlbum addPhotos:@[photoItem2]];

    NSArray *albumsSection = @[firstAlbum, secondAlbum];
    NSArray *mediaItemsSection = @[[[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFVideoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]],
                                   [[CLFPhotoItem alloc] initWithImage:[UIImage imageNamed:@"photo_background"]]];
    self.myPhotosSections = @[albumsSection, mediaItemsSection];
    self.sharedAlbums = @[firstAlbum, secondAlbum];
}

#pragma mark - UI configuration

- (void)configureBarItems {
    self.editPhotosBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(editPhotosBarButtonTapped:)];
    self.addNewPhotoBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_photo_icon"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(addNewPhotoBarButtonTapped:)];
    self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(doneBarButtonTapped:)];

    self.navigationItem.leftBarButtonItems = @[self.editPhotosBarButtonItem];
    self.navigationItem.rightBarButtonItems = @[[self fixedSpaceBarButtonItem], self.addNewPhotoBarButtonItem];
}

- (UIBarButtonItem *)fixedSpaceBarButtonItem {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:nil
                                                                                action:nil];
    fixedSpace.width = -12.0;

    return fixedSpace;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.topViewToolbar.barTintColor = self.navigationController.navigationBar.barTintColor;
    [self.segmentedControl removeAllSegments];
    [self.segmentedControl insertSegmentWithTitle:@"My Photos" atIndex:0 animated:NO];
    [self.segmentedControl insertSegmentWithTitle:@"Shared Photos" atIndex:1 animated:NO];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;

    self.myPhotosVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"CLFMyPhotosViewController"];
    self.myPhotosVC.myPhotosSections = self.myPhotosSections;
    [self addChildViewController:self.myPhotosVC];
    [self.containerView addSubview:self.myPhotosVC.view];
    [self.myPhotosVC didMoveToParentViewController:self];
    __weak typeof(self) weakSelf = self;
    self.myPhotosVC.selectedItemsHandler = ^(NSArray *selectedItems) {
        [weakSelf updateTitleForSelectedItems:selectedItems];
    };

    self.sharedPhotosVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"CLFSharedPhotosViewController"];
    self.sharedPhotosVC.sharedAlbums = self.sharedAlbums;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar hideBottomHairline];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar showBottomHairline];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.myPhotosVC.view.frame = self.containerView.bounds;

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self defaultPreferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    return [self defaultPrefersStatusBarHidden];
}

//TODO:Посмотреть лучшее решение.
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.myPhotosVC willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.sharedPhotosVC willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    [self updateTitleForEditing:editing];

    [self.myPhotosVC setEditing:editing animated:animated];
    [self.sharedPhotosVC setEditing:editing animated:animated];

    if (editing) {
        [self.navigationItem setLeftBarButtonItem:nil
                                         animated:animated];
        [self.navigationItem setRightBarButtonItems:@[self.doneBarButtonItem]
                                           animated:animated];
    }
    else {
        [self.navigationItem setLeftBarButtonItems:@[self.editPhotosBarButtonItem]
                                          animated:animated];
        if (self.sharedPhotosVC.parentViewController == self) {
            [self.navigationItem setRightBarButtonItems:nil
                                               animated:animated];
        } else {
            [self.navigationItem setRightBarButtonItems:@[[self fixedSpaceBarButtonItem], self.addNewPhotoBarButtonItem]
                                               animated:animated];
        }
    }
}

#pragma mark - Actions
- (void)segmentedControlAction:(UISegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0) {
        if (!self.isEditing) {
            [self.navigationItem setRightBarButtonItems:@[[self fixedSpaceBarButtonItem], self.addNewPhotoBarButtonItem]
                                               animated:YES];
        }
        [self transitionFromViewController:self.sharedPhotosVC toViewController:self.myPhotosVC];
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        if (!self.isEditing) {
            [self.navigationItem setRightBarButtonItems:nil
                                               animated:YES];
        }
        [self transitionFromViewController:self.myPhotosVC toViewController:self.sharedPhotosVC];
    }
}

- (void)editPhotosBarButtonTapped:(id)sender {
    [self setEditing:YES animated:YES];
}

- (void)addNewPhotoBarButtonTapped:(id)sender {

}

- (void)doneBarButtonTapped:(id)sender {
    [self setEditing:NO animated:YES];
}


#pragma mark - Private methods
- (void)updateTitleForEditing:(BOOL)editing {
    if (editing) {
        self.title = @"";
        self.detailTitle = @"";
        self.tabBarItem.title = @"Photos";
    } else {
        self.title = @"Photos";
        self.detailTitle = @"2 ALBUMS - 34 PHOTOS";
    }
}

- (void)updateTitleForSelectedItems:(NSArray *)selectedItems {
    if (selectedItems.count > 0) {
        self.title = [NSString stringWithFormat:@"%ld SELECTED", (long) selectedItems.count];
    } else {
        self.title = @"";
    }
    self.tabBarItem.title = @"Photos";
}

- (void)transitionFromViewController:(UIViewController *)fromController toViewController:(UIViewController *)toController {
    [fromController willMoveToParentViewController:nil];
    [self addChildViewController:toController];

    toController.view.frame = fromController.view.bounds;

    [self transitionFromViewController:fromController
                      toViewController:toController
                              duration:0.2
                               options:UIViewAnimationOptionCurveEaseIn
                            animations:nil
                            completion:^(BOOL finished) {
                                [toController didMoveToParentViewController:self];
                                [fromController removeFromParentViewController];
                            }];
}

@end
