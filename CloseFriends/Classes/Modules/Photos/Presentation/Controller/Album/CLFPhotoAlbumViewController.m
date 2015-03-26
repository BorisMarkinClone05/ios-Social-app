/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFPhotoAlbumViewController.h"
#import "CLFMacros.h"
#import "CLFAppearanceManager.h"

#import "CLFAlbumInterface.h"
#import "CLFPhotoAlbumCarouselAdapter.h"

#import "CLFContactsView.h"
#import "CLFContact.h"

#import "CLFPhotoAlbumPageAdapter.h"
#import "CLFPhotoViewController.h"
#import "CLFPhotoActionView.h"

#import "CLFPhotoDetailsViewController.h"

static NSString * const ShowDetailsSegueIdentifier = @"Show Details";

@interface CLFPhotoAlbumViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *carouselCollectionView;
@property (nonatomic, strong) CLFPhotoAlbumCarouselAdapter *carouselAdapter;

@property (weak, nonatomic) IBOutlet CLFPhotoActionView *actionView;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) CLFPhotoAlbumPageAdapter *pageAdapter;

@property (nonatomic, strong) id<CLFAlbumInterface> album;
@property (nonatomic, strong) id<CLFMediaItemInterface> currentMediaItem;

@property (nonatomic) BOOL scrollToCurrentMediaItemAfterViewDidLayout;

@property (weak, nonatomic) IBOutlet UILabel *likesAndCommentsLabel;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTapRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapRecognizer;

@end

@implementation CLFPhotoAlbumViewController

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
    self.titleFont = [UIFont fontWithName:@"Avenir-Heavy" size:15.0];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self
                                                                               action:@selector(shareBarButtonTapped:)];
    
    self.navigationItem.rightBarButtonItems = @[shareItem];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCarousel];
    [self configurePageController];
    [self configureLikeAndCommentsLabel];
    
    [self configureCarouselAdapter];
    [self configurePageAdapter];
    
    [self configureRecognizers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x1B1E1F);
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController]) {
        self.navigationController.navigationBar.barTintColor = [[CLFAppearanceManager sharedInstance].currentTheme navigationBarBarTintColor];
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.view.window && self.scrollToCurrentMediaItemAfterViewDidLayout && self.currentMediaItem) {
        self.scrollToCurrentMediaItemAfterViewDidLayout = NO;
        [self scrollCarouselToCurrentMediaItemAnimated:NO];
    }
}

#pragma mark - Configure UI

- (void)configureCarousel {
    self.carouselCollectionView.backgroundColor = UIColorFromRGB(0x313435);
}

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
                            @"pager" : self.pageController.view,
                            @"carousel" : self.carouselCollectionView
                            };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pager]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[carousel][pager]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (void)configureLikeAndCommentsLabel {
    self.likesAndCommentsLabel.font = [UIFont fontWithName:@"Avenir-Black" size:10.0];
    self.likesAndCommentsLabel.textColor = [UIColorFromRGB(0xFFFFFF) colorWithAlphaComponent:0.7];
}

- (void)configureRecognizers {
    [self.singleTapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];
}

#pragma mark - UI rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.carouselCollectionView.collectionViewLayout invalidateLayout];
    [self.carouselCollectionView layoutIfNeeded];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if (self.carouselCollectionView.indexPathsForSelectedItems.count > 0) {
        NSIndexPath *selectedIndexPath = self.carouselCollectionView.indexPathsForSelectedItems[0];
        [self.carouselCollectionView scrollToItemAtIndexPath:selectedIndexPath
                                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                    animated:YES];
    }
}

#pragma mark - Configure Adapters

- (void)configureCarouselAdapter {
    if (self.carouselCollectionView && self.album) {
        self.carouselAdapter = [[CLFPhotoAlbumCarouselAdapter alloc] initWithCollectionView:self.carouselCollectionView
                                                                                      album:self.album];
        
        __weak typeof(self)weakSelf = self;
        self.carouselAdapter.didSelectItemBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
            [collectionView scrollToItemAtIndexPath:indexPath
                                   atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                           animated:YES];
            
            CLFPhotoViewController *vc = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:NSStringFromClass(CLFPhotoViewController.class)];
            vc.mediaItem = weakSelf.album.mediaItems[indexPath.item];
            
            NSUInteger idx = [weakSelf.album.mediaItems indexOfObject:weakSelf.currentMediaItem];
            [weakSelf.pageController setViewControllers:@[vc]
                                              direction:idx < indexPath.item ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                               animated:YES
                                             completion:^(BOOL finished) {
                                                 weakSelf.currentMediaItem = vc.mediaItem;
                                             }];
        };
    }
}

- (void)configurePageAdapter {
    if (self.pageController && self.album) {
        self.pageAdapter = [[CLFPhotoAlbumPageAdapter alloc] initWithPageController:self.pageController
                                                                         mediaItems:self.album.mediaItems
                                                                   currentMediaItem:self.currentMediaItem];
        
        __weak typeof(self)weakSelf = self;
        self.pageAdapter.didChangePageBlock = ^(id<CLFMediaItemInterface> currentMediaItem) {
            weakSelf.currentMediaItem = currentMediaItem;
            [weakSelf scrollCarouselToCurrentMediaItemAnimated:YES];
        };
    }
}

#pragma mark - Public methods

- (void)setAlbum:(id<CLFAlbumInterface>)album
       mediaItem:(id<CLFMediaItemInterface>)mediaItem {
    if (album != _album) {
        self.album = album;
        
        if (mediaItem) {
            self.currentMediaItem = mediaItem;
        }
        else if (self.album.mediaItems.count > 0) {
            self.currentMediaItem = self.album.mediaItems[0];
        }
        
        self.title = album.name;
        self.detailTitle = [NSString stringWithFormat:@"%lu PHOTOS", (unsigned long)album.mediaItems.count];
        
        if ([self isViewLoaded]) {
            [self configureCarouselAdapter];
            [self.carouselCollectionView reloadData];
            [self.carouselCollectionView layoutIfNeeded];
            [self scrollCarouselToCurrentMediaItemAnimated:NO];
            
            [self configurePageAdapter];
        }
        else {
            self.scrollToCurrentMediaItemAfterViewDidLayout = YES;
        }
    }
}

#pragma mark - Carousel

- (void)scrollCarouselToCurrentMediaItemAnimated:(BOOL)animated {
    if (self.carouselCollectionView && self.currentMediaItem) {
        for (NSIndexPath *indexPath in self.carouselCollectionView.indexPathsForSelectedItems) {
            [self.carouselCollectionView deselectItemAtIndexPath:indexPath
                                                        animated:NO];
        }
        
        NSIndexPath *ip = [NSIndexPath indexPathForItem:[self.album.mediaItems indexOfObject:self.currentMediaItem]
                                              inSection:0];
        
        [self.carouselCollectionView selectItemAtIndexPath:ip
                                                  animated:animated
                                            scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL result = YES;
    
    if (gestureRecognizer == self.singleTapRecognizer ||
        gestureRecognizer == self.doubleTapRecognizer) {
        CGPoint touchLocation = [gestureRecognizer locationInView:self.view];
        result = CGRectContainsPoint(self.pageController.view.frame, touchLocation);
    }
    
    return result;
}

#pragma mark - Actions

- (void)shareBarButtonTapped:(id)sender {
    
}

- (IBAction)singleTapAction:(id)sender {
    [self performSegueWithIdentifier:ShowDetailsSegueIdentifier
                              sender:self];
}

- (IBAction)doubleTapAction:(id)sender {
    
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ShowDetailsSegueIdentifier]) {
        CLFPhotoDetailsViewController *detailVC = (CLFPhotoDetailsViewController *)segue.destinationViewController;
        [detailVC setMediaItems:self.album.mediaItems currentMediaItem:self.currentMediaItem];
    }
}

#pragma mark -

@end
