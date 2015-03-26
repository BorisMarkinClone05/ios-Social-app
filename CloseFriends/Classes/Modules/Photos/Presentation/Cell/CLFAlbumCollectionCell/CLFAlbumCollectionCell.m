/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFAlbumCollectionCell.h"
#import "CLFMacros.h"
#import "CLFAlbumInterface.h"
#import "CLFMediaItemInterface.h"
#import "CLFGradientView.h"

@interface CLFAlbumCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet CLFGradientView *gradientView;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *numberOfPhotosView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPhotosLabel;

@end

@implementation CLFAlbumCollectionCell

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];

    CAGradientLayer *gradientLayer = (CAGradientLayer *) self.gradientView.layer;
    gradientLayer.colors = @[(id) [UIColor clearColor].CGColor, (id) [[UIColor blackColor] colorWithAlphaComponent:0.4f].CGColor];

    self.albumNameLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:20.0f];
    self.albumNameLabel.textColor = [UIColor whiteColor];

    self.dateLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:10.0f];
    self.dateLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];

    self.numberOfPhotosView.layer.cornerRadius = 2.0f;
    self.numberOfPhotosView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    self.numberOfPhotosLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0f];
    self.numberOfPhotosLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Public methods

- (void)configureWithAlbum:(id<CLFAlbumInterface>)album {
    if (album) {
        id <CLFMediaItemInterface> mediaItem = album.mediaItems[0];
        self.backgroundImageView.image = mediaItem.thumbnail;
        self.albumNameLabel.text = album.name;
        self.dateLabel.text = album.creationDateAsString;
        self.numberOfPhotosLabel.text = [self stringForItemsCount:album.mediaItems.count];
    }
}

#pragma mark - Private methods

- (NSString *)stringForItemsCount:(NSInteger)count {
    if (count == 1) {
        return @"1 PHOTO";
    } else {
        return [NSString stringWithFormat:@"%ld PHOTOS", (long) count];
    }
}

@end