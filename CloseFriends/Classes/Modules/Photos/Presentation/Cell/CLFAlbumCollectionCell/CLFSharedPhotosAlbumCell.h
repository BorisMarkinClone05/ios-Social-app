/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;
#import "CLFAlbumCollectionCell.h"

@interface CLFSharedPhotosAlbumCell : CLFAlbumCollectionCell

@property (nonatomic, copy) void(^deleteBlock)();

@end