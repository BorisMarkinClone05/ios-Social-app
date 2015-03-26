/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFAssetGridViewController.h"
#import "CLFAssetPickerController.h"
#import "CLFGridViewCell.h"


@import Photos;

@interface CLFAssetGridViewController () <PHPhotoLibraryChangeObserver>

@property (strong) PHCachingImageManager *imageManager;
@end

@implementation CLFAssetGridViewController

static NSString * const CellReuseIdentifier = @"Cell";
static CGSize AssetGridThumbnailSize;

- (void)awakeFromNib
{
    self.imageManager = [[PHCachingImageManager alloc] init];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    [self addActivityIndicatorToNavigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    
    requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.synchronous = NO;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    self.myCache = [[NSCache alloc] init];

    [self setupAssetsArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.myCache removeAllObjects];
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize cellSize = CGSizeZero;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        myCell_Size = MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) / 3.0f - 2.0f;
    else
        myCell_Size = MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) / 7.0f - 5.0f;
    
    cellSize = CGSizeMake(myCell_Size, myCell_Size);
    
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize = cellSize;

    AssetGridThumbnailSize = CGSizeMake(cellSize.width*2.0f, cellSize.height*2.0f);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self removeActivityIndicatorFromNavigationBar];
}

- (void)addActivityIndicatorToNavigationBar
{
    if (!_indicatorView)
    {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView setHidesWhenStopped:YES];
    }
    
    UIBarButtonItem *itemIndicator = [[UIBarButtonItem alloc] initWithCustomView:_indicatorView];
    [self.navigationItem setRightBarButtonItem:itemIndicator];
    [_indicatorView startAnimating];
}

- (void)removeActivityIndicatorFromNavigationBar
{
    [_indicatorView stopAnimating];
}

- (void) setupAssetsArray
{
    [assetsArray removeAllObjects];
    assetsArray = nil;
    assetsArray = [[NSMutableArray alloc] init];

    for (int i=0; i<self.assetsFetchResults.count; i++)
    {
        PHAsset* asset = [self.assetsFetchResults objectAtIndex:(self.assetsFetchResults.count - 1 - i)];
        
        if (asset.mediaType == self.filterType)
        {
            [assetsArray addObject:asset];
        }
    }
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // check if there are changes to the assets (insertions, deletions, updates)
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
        
        if (collectionChanges)
        {
            // get the new fetch result
            self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
            
            [self setupAssetsArray];
            
            [self.collectionView reloadData];
        }
    });
}


#pragma mark -
#pragma mark - UICollectionViewDataSource

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [assetsArray count];

    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CLFGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    
    // Increment the cell's tag
    NSInteger currentTag = cell.tag + 1;
    cell.tag = currentTag;
    
    PHAsset *asset = [assetsArray objectAtIndex:indexPath.item];
    
    if (asset.mediaType == PHAssetMediaTypeImage)   //Photo
    {
        [cell hideGrayBgView];
    }
    else if (asset.mediaType == PHAssetMediaTypeVideo)  //Video
    {
        [self.imageManager requestImageForAsset:asset
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeDefault
                                        options:requestOptions
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      
                                      if (cell.tag == currentTag)
                                      {
                                          cell.thumbnailImage = result;
                                      }
                                  }];
        
        //Video Duration
        CGFloat duration = asset.duration;
        NSString* durationStr = [self timeToStr:duration];
        
        [cell setDurationLabelString:durationStr];
        [self.myCache setObject:durationStr forKey:[NSString stringWithFormat:@"%@-videoDuration", asset.localIdentifier]];
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedAsset = [assetsArray objectAtIndex:indexPath.item];
    
    [self didSelectedAsset];
    
    return YES;
}

- (NSString *)timeToStr:(CGFloat)time
{
    int min = floor(time / 60);
    int sec = floor(time - min * 60);
    
    NSString *minStr = [NSString stringWithFormat:@"%d", min];
    NSString *secStr = [NSString stringWithFormat:sec >= 10 ? @"%d" : @"0%d", sec];
    
    return [NSString stringWithFormat:@"%@:%@", minStr, secStr];
}

- (void)didSelectedAsset
{
    if ([self.customAssetPickerController.delegate respondsToSelector:@selector(customAssetsPickerController:didFinishPickingAsset:)])
    {
        [self.customAssetPickerController.delegate customAssetsPickerController:self.customAssetPickerController didFinishPickingAsset:self.selectedAsset];
    }
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    popoverController = nil;
}

- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion
{

}


@end


