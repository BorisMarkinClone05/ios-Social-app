/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import <UIKit/UIKit.h>

@import Photos;

@protocol CLFAssetPickerControllerDelegate;

@interface CLFAssetPickerController : UINavigationController

@property (nonatomic, weak) id <CLFAssetPickerControllerDelegate, UINavigationControllerDelegate> delegate;
@property (nonatomic) PHAssetMediaType filterType;

@end


@protocol CLFAssetPickerControllerDelegate <NSObject>

@optional

- (void)customAssetsPickerController:(CLFAssetPickerController *)picker didFinishPickingAsset:(PHAsset*) asset;
- (void)customAssetsPickerControllerDidCancel:(CLFAssetPickerController *)picker;
- (void)customAssetsPickerController:(CLFAssetPickerController *)picker failedWithError:(NSError *)error;

@end