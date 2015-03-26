/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

#import "CLFBaseViewController.h"

@protocol CLFMediaItemInterface;

@interface CLFPhotoDetailsViewController : CLFBaseViewController

- (void)setMediaItems:(NSArray *)mediaItems currentMediaItem:(id<CLFMediaItemInterface>)currentMediaItem;

@end
