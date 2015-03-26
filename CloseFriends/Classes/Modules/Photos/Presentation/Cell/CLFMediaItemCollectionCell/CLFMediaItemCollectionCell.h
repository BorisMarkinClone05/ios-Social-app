/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import UIKit;

@protocol CLFMediaItemInterface;

@interface CLFMediaItemCollectionCell : UICollectionViewCell

@property (nonatomic, assign) BOOL highlightThumbnailWhenSelected;
@property (nonatomic, assign, getter=isEditing) BOOL editing;

- (void)configureWithMediaItem:(id<CLFMediaItemInterface>)mediaItem;

@end