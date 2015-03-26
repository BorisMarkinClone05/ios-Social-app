/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFPhotoDetailsViewController.h"

#import "CLFPhotoActionView.h"
#import "CLFMacros.h"

#import "CLFPhotoAlbumPageAdapter.h"

@interface CLFPhotoDetailsViewController ()

@property (weak, nonatomic) IBOutlet CLFPhotoActionView *actionView;
@property (weak, nonatomic) IBOutlet UILabel *likesAndCommentsLabel;

@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) CLFPhotoAlbumPageAdapter *pageAdapter;

@property (nonatomic, strong) NSArray *mediaItems;
@property (nonatomic, strong) id<CLFMediaItemInterface> currentMediaItem;

@end

@implementation CLFPhotoDetailsViewController

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    self.titleFont = [UIFont fontWithName:@"Avenir-Black" size:11.0];
    self.titleColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    self.detailTitleFont = [UIFont fontWithName:@"Avenir-Roman" size:10.0];
    self.detailTitleColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    self.title = @"PHOTO DETAILS";
    self.detailTitle = @"23/11/2014";
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self
                                                                               action:@selector(shareBarButtonTapped:)];
    
    self.navigationItem.rightBarButtonItems = @[shareItem];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configurePageController];
    [self configureLikeAndCommentsLabel];
    
    [self configurePageAdapter];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UINavigationBar *navbar = self.navigationController.navigationBar;
    navbar.barTintColor = [UIColor clearColor];
    [navbar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Public methods

- (void)setMediaItems:(NSArray *)mediaItems currentMediaItem:(id<CLFMediaItemInterface>)currentMediaItem {
    self.mediaItems = mediaItems;
    
    if (currentMediaItem) {
        self.currentMediaItem = currentMediaItem;
    }
    else if (self.mediaItems.count > 0) {
        self.currentMediaItem = self.mediaItems[0];
    }
    
    if ([self isViewLoaded]) {
        [self configurePageAdapter];
    }
}

#pragma mark - Configure UI

- (void)configurePageController {
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:@{UIPageViewControllerOptionInterPageSpacingKey : @16.0}];
    self.pageController.view.backgroundColor = [UIColor clearColor];
    self.pageController.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addChildViewController:self.pageController];
    [self.view insertSubview:self.pageController.view
                     atIndex:0];
    [self.pageController didMoveToParentViewController:self];
    
    self.pageController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{
                            @"pager" : self.pageController.view
                            };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pager]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pager]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (void)configureLikeAndCommentsLabel {
    self.likesAndCommentsLabel.font = [UIFont fontWithName:@"Avenir-Black" size:10.0];
    self.likesAndCommentsLabel.textColor = [UIColorFromRGB(0xFFFFFF) colorWithAlphaComponent:0.7];
}

#pragma mark - Adapter

- (void)configurePageAdapter {
    if (self.pageController && self.mediaItems) {
        self.pageAdapter = [[CLFPhotoAlbumPageAdapter alloc] initWithPageController:self.pageController
                                                                         mediaItems:self.mediaItems
                                                                   currentMediaItem:self.currentMediaItem];
        
        __weak typeof(self)weakSelf = self;
        self.pageAdapter.didChangePageBlock = ^(id<CLFMediaItemInterface> currentMediaItem) {
            weakSelf.currentMediaItem = currentMediaItem;
        };
    }
}

#pragma mark - Actions

- (void)shareBarButtonTapped:(id)sender {
    
}

#pragma mark -

@end
