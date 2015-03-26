/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import Foundation;

#import "CLFMediaItemInterface.h"

@interface CLFVideoItem : NSObject <CLFMediaItemInterface>

- (instancetype)initWithImage:(UIImage *)image;

@end