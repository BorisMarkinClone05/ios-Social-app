/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFPhotoAlbumCarouselAdapter.h"
#import "CLFAlbumInterface.h"
#import "CLFMediaItemCollectionCell.h"

static NSString * const MediaCellIdentifier = @"CLFMediaItemCollectionCell";

static CGFloat const kItemSideSize = 78.0;

@interface CLFPhotoAlbumCarouselAdapter ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) id<CLFAlbumInterface> album;

@end

@implementation CLFPhotoAlbumCarouselAdapter

#pragma mark - Initialization

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                                 album:(id<CLFAlbumInterface>)album {
    if (self = [super init]) {
        self.collectionView = collectionView;
        self.album = album;
        
        [self configureCollectionView];
    }
    return self;
}

- (void)configureCollectionView {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFMediaItemCollectionCell class])
                                                    bundle:nil]
          forCellWithReuseIdentifier:MediaCellIdentifier];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(kItemSideSize, kItemSideSize);
    layout.minimumInteritemSpacing = 10.0;
    layout.minimumLineSpacing = 12.0;
    layout.headerReferenceSize = CGSizeZero;
    layout.footerReferenceSize = CGSizeZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.album.mediaItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLFMediaItemCollectionCell *cell = (CLFMediaItemCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MediaCellIdentifier
                                                                                                               forIndexPath:indexPath];
    [cell configureWithMediaItem:self.album.mediaItems[indexPath.item]];
    cell.highlightThumbnailWhenSelected = YES;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(collectionView, indexPath);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset = UIEdgeInsetsZero;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    const NSUInteger numberOfItemsInSection = [collectionView numberOfItemsInSection:section];
    const CGFloat defaultLeftRightInset = 6.0;
    const CGFloat itemsWidth = numberOfItemsInSection * layout.itemSize.width + (numberOfItemsInSection-1) *layout.minimumInteritemSpacing + 2*defaultLeftRightInset;
    
    
    if (itemsWidth < CGRectGetWidth(collectionView.bounds)) {
        CGFloat leftRightInset = (CGRectGetWidth(collectionView.bounds) - itemsWidth)*0.5;
        inset.left = leftRightInset;
        inset.right = leftRightInset;
    }
    else {
        inset.left = defaultLeftRightInset;
        inset.right = defaultLeftRightInset;
    }
    
    return inset;
}

#pragma mark -

@end
