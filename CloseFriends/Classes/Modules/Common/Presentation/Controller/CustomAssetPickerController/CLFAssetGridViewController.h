/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import UIKit;
@import Photos;

@class CLFAssetPickerController;
@class CLFGridViewCell;


@interface CLFAssetGridViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>
{
    NSMutableArray* assetsArray;
    
    UIActivityIndicatorView *_indicatorView;
    
    PHImageRequestOptions* requestOptions;
    
    NSOperationQueue *_thumbnailQueue;
    
    CLFGridViewCell* selectedCell;
    
    CGFloat myCell_Size;
}

@property(nonatomic, weak) CLFAssetPickerController* customAssetPickerController;

@property (nonatomic) PHAssetMediaType filterType;
@property (strong) PHFetchResult *assetsFetchResults;
@property (strong) PHAssetCollection *assetCollection;
@property (strong) NSCache* myCache;
@property (nonatomic, strong) PHAsset *selectedAsset;


@end
