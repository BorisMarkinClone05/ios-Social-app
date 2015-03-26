/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFPhotoAlbumPageAdapter.h"
#import "CLFAlbumInterface.h"
#import "CLFPhotoViewController.h"
#import "NSArray+Additions.h"
#import "CLFStoryboardProvider.h"

@interface CLFPhotoAlbumPageAdapter ()

@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) NSArray *mediaItems;

@end

@implementation CLFPhotoAlbumPageAdapter

#pragma mark - Initialization

- (instancetype)initWithPageController:(UIPageViewController *)pageController
                            mediaItems:(NSArray *)mediaItems
                      currentMediaItem:(id<CLFMediaItemInterface>)mediaItem {
    if (self = [super init]) {
        self.pageController = pageController;
        self.pageController.dataSource = self;
        self.pageController.delegate = self;
        
        self.mediaItems = mediaItems;
        
        if (mediaItem) {
            [self.pageController setViewControllers:@[[self photoViewControllerWithMediaItem:mediaItem]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        }
    }
    return self;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(CLFPhotoViewController *)viewController {
    CLFPhotoViewController *vc = nil;
    
    id<CLFMediaItemInterface> prevMediaItem = [self.mediaItems previousObjectForObject:viewController.mediaItem];
    if (prevMediaItem) {
        vc = [self photoViewControllerWithMediaItem:prevMediaItem];
    }
    
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(CLFPhotoViewController *)viewController {
    CLFPhotoViewController *vc = nil;
    
    id<CLFMediaItemInterface> nextMediaItem = [self.mediaItems nextObjectForObject:viewController.mediaItem];
    if (nextMediaItem) {
        vc = [self photoViewControllerWithMediaItem:nextMediaItem];
    }
    
    return vc;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (completed) {
        if (self.didChangePageBlock) {
            CLFPhotoViewController *vc = pageViewController.viewControllers[0];
            self.didChangePageBlock(vc.mediaItem);
        }
    }
}

#pragma mark - Private

- (CLFPhotoViewController *)photoViewControllerWithMediaItem:(id<CLFMediaItemInterface>)mediaItem {
    CLFPhotoViewController *vc = [[[CLFStoryboardProvider sharedInstance] photosStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass(CLFPhotoViewController.class)];
    vc.mediaItem = mediaItem;
    
    return vc;
}

#pragma mark -

@end
