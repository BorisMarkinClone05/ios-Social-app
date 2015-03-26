/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

#import "CLFBaseViewController.h"

@protocol CLFAlbumInterface;
@protocol CLFMediaItemInterface;

@interface CLFPhotoAlbumViewController : CLFBaseViewController

- (void)setAlbum:(id<CLFAlbumInterface>)album
       mediaItem:(id<CLFMediaItemInterface>)mediaItem;

@end
