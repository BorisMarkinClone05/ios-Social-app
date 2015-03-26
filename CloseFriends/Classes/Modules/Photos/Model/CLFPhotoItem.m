/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFPhotoItem.h"

@interface CLFPhotoItem ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation CLFPhotoItem

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