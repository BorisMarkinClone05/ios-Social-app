/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFGridViewCell.h"


@interface CLFGridViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView* imageView;
@property (strong) IBOutlet UIView* grayBgView;
@property (strong) IBOutlet UILabel* durationLabel;

@end

@implementation CLFGridViewCell

- (void)awakeFromNib
{
    self.durationLabel.shadowColor = [UIColor blackColor];
    self.durationLabel.shadowOffset = CGSizeMake(0.5f, 0.5f);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
}

- (void)changeContentForShape
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage
{
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

- (void)setDurationLabelString:(NSString*) string
{
    self.durationLabel.text = string;
}

- (void)hideGrayBgView
{
    self.grayBgView.hidden = YES;
}



@end
