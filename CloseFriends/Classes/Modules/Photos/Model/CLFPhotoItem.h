/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import UIKit;
#import "CLFMediaItemInterface.h"

@interface CLFPhotoItem : NSObject <CLFMediaItemInterface>

- (instancetype)initWithImage:(UIImage *)image;

@end