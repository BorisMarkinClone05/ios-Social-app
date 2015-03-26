/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

@protocol CLFMediaItemInterface;

@interface CLFPhotoViewController : UIViewController

@property (nonatomic, strong) id<CLFMediaItemInterface> mediaItem;

@end
