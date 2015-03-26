/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import UIKit;

@interface CLFMyPhotosViewController : UIViewController

@property (nonatomic, copy) void(^selectedItemsHandler)(NSArray *selectedItems);

@property (nonatomic, strong) NSArray *myPhotosSections;

@end