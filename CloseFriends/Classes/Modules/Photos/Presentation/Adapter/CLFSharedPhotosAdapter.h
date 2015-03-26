/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import UIKit;

@interface CLFSharedPhotosAdapter : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                                albums:(NSArray *)albums;

- (void)updateContentForEditing:(BOOL)editing;
@end