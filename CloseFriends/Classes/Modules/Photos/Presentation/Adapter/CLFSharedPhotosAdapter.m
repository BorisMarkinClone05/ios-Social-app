/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFSharedPhotosAdapter.h"
#import "CLFSharedPhotosAlbumCell.h"

static NSString * const CLFSharedPhotosAlbumCellIdentifier = @"CLFSharedPhotosAlbumCell";

static const CGFloat kAlbumHeight = 185.0f;

@interface CLFSharedPhotosAdapter ()

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *albums;

@property (nonatomic) BOOL editing;

@end

@implementation CLFSharedPhotosAdapter

#pragma mark - Initialization

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView albums:(NSArray *)albums {
    self = [super init];
    if (self) {
        [self commonInitializationWithCollectionView:collectionView];

        _albums = [albums mutableCopy];
    }
    return self;
}

- (void)commonInitializationWithCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;

    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFSharedPhotosAlbumCell class])
                                                bundle:nil]
      forCellWithReuseIdentifier:CLFSharedPhotosAlbumCellIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLFSharedPhotosAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CLFSharedPhotosAlbumCellIdentifier forIndexPath:indexPath];
    [cell configureWithAlbum:self.albums[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    cell.deleteBlock = ^{
        NSIndexPath *blockIndexPath = [weakSelf.collectionView indexPathForCell:weakCell];
        [weakSelf.albums removeObjectAtIndex:blockIndexPath.row];
        [weakSelf.collectionView deleteItemsAtIndexPaths:@[blockIndexPath]];
    };
    cell.editing = self.editing;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, kAlbumHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

#pragma mark - Public methods

- (void)updateContentForEditing:(BOOL)editing {
    self.editing = editing;
    [self.collectionView reloadData];
}

@end