/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

@protocol CLFMediaItemInterface;

@interface CLFPhotoActionView : UIView

- (void)configureWithMediaItem:(id<CLFMediaItemInterface>)mediaItem;

@end
