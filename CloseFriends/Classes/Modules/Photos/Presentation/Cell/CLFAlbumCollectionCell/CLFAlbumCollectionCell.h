/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import UIKit;

@protocol CLFAlbumInterface;

@interface CLFAlbumCollectionCell : UICollectionViewCell

@property (nonatomic, assign, getter=isEditing) BOOL editing;

- (void)configureWithAlbum:(id<CLFAlbumInterface>)album;

@end