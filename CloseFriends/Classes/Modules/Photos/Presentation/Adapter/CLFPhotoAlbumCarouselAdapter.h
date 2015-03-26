/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

@protocol CLFAlbumInterface;

@interface CLFPhotoAlbumCarouselAdapter : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) void(^didSelectItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                                 album:(id<CLFAlbumInterface>)album;

@end
