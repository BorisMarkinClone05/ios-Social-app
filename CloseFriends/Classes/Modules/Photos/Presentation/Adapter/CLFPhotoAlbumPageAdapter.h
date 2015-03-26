/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

@protocol CLFMediaItemInterface;

@interface CLFPhotoAlbumPageAdapter : NSObject <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, copy) void(^didChangePageBlock)(id<CLFMediaItemInterface> currentMediaItem);

- (instancetype)initWithPageController:(UIPageViewController *)pageController
                            mediaItems:(NSArray *)mediaItems
                      currentMediaItem:(id<CLFMediaItemInterface>)mediaItem;

@end
