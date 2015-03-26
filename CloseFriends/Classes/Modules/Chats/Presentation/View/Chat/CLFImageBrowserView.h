/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>

@interface CLFImageBrowserView : UIView

@property (strong, nonatomic) UIImage *image;
@property (nonatomic) CGRect startFrame;

- (void)show;
- (void)hide;

@end
