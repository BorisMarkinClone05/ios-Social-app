/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>

@interface CLFPhotoScrollView : UIScrollView

@property (nonatomic, strong) UIImage *photo;

- (void)resetZoom;

@end
