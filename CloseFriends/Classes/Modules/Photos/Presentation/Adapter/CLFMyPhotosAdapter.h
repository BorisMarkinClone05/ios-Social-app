/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import UIKit;


@interface CLFMyPhotosAdapter : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) void(^didSelectItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
@property (nonatomic, copy) void(^didChangedSelectedItemsBlock)(NSArray *selectedItems);

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                              sections:(NSArray *)sections;

- (void)updateContentForEditing:(BOOL)editing;

@end