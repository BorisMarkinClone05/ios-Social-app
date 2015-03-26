/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import UIKit;
@import Photos;


@interface CLFGridViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *thumbnailImage;

- (void)setDurationLabelString:(NSString*) string;
- (void)hideGrayBgView;

@end

