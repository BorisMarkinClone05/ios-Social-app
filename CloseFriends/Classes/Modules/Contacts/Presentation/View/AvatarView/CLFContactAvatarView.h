/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

@protocol CLFContactInterface;

@interface CLFContactAvatarView : UIView

@property (nonatomic, assign) IBInspectable BOOL statusViewHidden;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)configureWithContact:(id<CLFContactInterface>)contact;

@end
