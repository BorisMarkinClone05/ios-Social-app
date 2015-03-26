/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import UIKit;
@import Photos;

@class CLFAssetPickerController;

@interface CLFAlbumsViewController : UITableViewController
{
    PHAssetMediaType filterType;
    
    UIActivityIndicatorView *_indicatorView;
}

@property(nonatomic, weak) CLFAssetPickerController* customAssetPickerController;

@end
