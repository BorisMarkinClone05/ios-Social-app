/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFVideoItem.h"

@interface CLFVideoItem ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation CLFVideoItem

#pragma mark - Initialization

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

#pragma mark - CLFMediaItemInterface
- (UIImage *)thumbnail {
    return self.image;
}
@end