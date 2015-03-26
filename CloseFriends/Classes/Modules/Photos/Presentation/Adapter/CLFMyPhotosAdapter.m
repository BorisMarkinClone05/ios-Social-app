/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFMyPhotosAdapter.h"
#import "CLFMediaItemCollectionCell.h"
#import "CLFAlbumInterface.h"
#import "CLFMediaItemInterface.h"
#import "CLFMediaItemsSupplementaryView.h"
#import "CLFMyPhotosAlbumCell.h"

static NSString * const CLFMyPhotosAlbumCellIdentifier = @"CLFMyPhotosAlbumCell";
static NSString * const CLFMediaItemCollectionCellIdentifier = @"CLFMediaItemCollectionCell";
static NSString * const CLFMediaItemsSupplementaryIdentifier = @"CLFMediaItemsSupplementaryView";

static const CGFloat kMediaItemCellIndent = 9.0f;
static const CGFloat kMediaItemCellMinimumSpace = 10.0f;
static const CGFloat kMediaItemsHeaderHeight = 30.0f;
static const CGFloat kAlbumHeight = 185.0f;

static const NSInteger portraitNumberOfMediaItems = 4;
static const NSInteger landscapeNumberOfMediaItems = 6;

@interface CLFMyPhotosAdapter ()

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSMutableArray *selectedItems;

@property (nonatomic) BOOL editing;

@property (nonatomic) CGFloat portraitMediaItemSideSize;
@property (nonatomic) CGFloat landscapeMediaItemSideSize;

@end

@implementation CLFMyPhotosAdapter

#pragma mark - Initialization

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                              sections:(NSArray *)sections {
    self = [super init];
    if (self) {
        [self commonInitializationWithCollectionView:collectionView];

        _sections = sections;
    }
    return self;
}

- (void)commonInitializationWithCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;

    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFMyPhotosAlbumCell class])
                                                bundle:nil]
      forCellWithReuseIdentifier:CLFMyPhotosAlbumCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFMediaItemCollectionCell class])
                                                bundle:nil]
      forCellWithReuseIdentifier:CLFMediaItemCollectionCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFMediaItemsSupplementaryView class])
                                                bundle:nil]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
            withReuseIdentifier:CLFMediaItemsSupplementaryIdentifier];

    _selectedItems = [[NSMutableArray alloc] init];

    _portraitMediaItemSideSize =  CGFLOAT_MAX;
    _landscapeMediaItemSideSize = CGFLOAT_MAX;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [(NSArray *) self.sections[section] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CLFMediaItemsSupplementaryView *supplementaryView= nil;
    if (indexPath.section == 1) {
        supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CLFMediaItemsSupplementaryIdentifier forIndexPath:indexPath];
        supplementaryView.title = @"PHOTOS AND VIDEOS";
    }
    return supplementaryView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [self albumCellForIndexPath:indexPath];
    } else {
        cell = [self mediaItemCellForIndexPath:indexPath];
    }
    return cell;
}

- (CLFAlbumCollectionCell *)albumCellForIndexPath:(NSIndexPath *)indexPath {
    CLFAlbumCollectionCell *albumCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CLFMyPhotosAlbumCellIdentifier forIndexPath:indexPath];
    id<CLFAlbumInterface> album = self.sections[indexPath.section][indexPath.row];
    [albumCell configureWithAlbum:album];
    albumCell.editing = self.editing;
    return albumCell;

}

- (CLFMediaItemCollectionCell *)mediaItemCellForIndexPath:(NSIndexPath *)indexPath {
    CLFMediaItemCollectionCell *mediaItemCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CLFMediaItemCollectionCellIdentifier forIndexPath:indexPath];
    id<CLFMediaItemInterface> mediaItem = self.sections[indexPath.section][indexPath.row];
    [mediaItemCell configureWithMediaItem:mediaItem];
    mediaItemCell.editing = self.editing;
    return mediaItemCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(collectionView.bounds.size.width, kAlbumHeight);
    } else {
        if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
            return CGSizeMake(self.portraitMediaItemSideSize, self.portraitMediaItemSideSize);
        } else {
            return CGSizeMake(self.landscapeMediaItemSideSize, self.landscapeMediaItemSideSize);
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } else {
        return UIEdgeInsetsMake(kMediaItemCellIndent, kMediaItemCellIndent, kMediaItemCellIndent, kMediaItemCellIndent);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 0.0f;
    } else {
        return kMediaItemCellMinimumSpace;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kMediaItemCellMinimumSpace;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(collectionView.bounds.size.width, kMediaItemsHeaderHeight);
    } else {
        return CGSizeMake(0.0f, 0.0f);
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
        id item = self.sections[indexPath.section][indexPath.row];
        [self.selectedItems addObject:item];
        [self performDidChangedSelectedItemsBlock];
    } else {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        if (self.didSelectItemBlock) {
            self.didSelectItemBlock(collectionView, indexPath);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
        id item = self.sections[indexPath.section][indexPath.row];
        [self.selectedItems removeObject:item];
        [self performDidChangedSelectedItemsBlock];
    }
}

#pragma mark - Public methods

- (void)updateContentForEditing:(BOOL)editing {
    self.editing = editing;
    [self.selectedItems removeAllObjects];
    [self.collectionView reloadData];
}

- (CGFloat)portraitMediaItemSideSize {
    if (_portraitMediaItemSideSize == CGFLOAT_MAX) {
        _portraitMediaItemSideSize = [self sideSizeForNumberOfMediaItems:portraitNumberOfMediaItems];;
    }
    return _portraitMediaItemSideSize;
}

- (CGFloat)landscapeMediaItemSideSize {
    if (_landscapeMediaItemSideSize == CGFLOAT_MAX) {
        _landscapeMediaItemSideSize = [self sideSizeForNumberOfMediaItems:landscapeNumberOfMediaItems];
    }
    return _landscapeMediaItemSideSize;
}

#pragma mark - Private methods

- (void)performDidChangedSelectedItemsBlock {
    if (self.didChangedSelectedItemsBlock) {
        self.didChangedSelectedItemsBlock(self.selectedItems);
    }
};

- (CGFloat)sideSizeForNumberOfMediaItems:(NSInteger)numberOfMediaItems {
    CGFloat width = self.collectionView.bounds.size.width;
    CGFloat sideSize;
    if (numberOfMediaItems > 1) {
         sideSize = (width - (2 * kMediaItemCellIndent + kMediaItemCellMinimumSpace * (numberOfMediaItems - 1))) / numberOfMediaItems;
    } else {
        sideSize = width - 2 * kMediaItemCellIndent;
    }
    return sideSize;
};

@end