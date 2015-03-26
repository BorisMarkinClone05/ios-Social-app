/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFMediaItemCollectionCell.h"
#import "CLFMediaItemInterface.h"
#import "CLFVideoItem.h"
#import "CLFMacros.h"
#import "CLFSelectionView.h"

@interface CLFMediaItemCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet CLFSelectionView *selectionView;

@end

@implementation CLFMediaItemCollectionCell

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];

    self.playView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    self.playView.layer.cornerRadius = 19.0f;
    self.playView.layer.borderWidth = 1.0f;
    self.playView.layer.borderColor = [UIColor whiteColor].CGColor;

    self.timeLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:10.0f];
    self.timeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];

    self.selectionView.hidden = YES;
}

#pragma mark - UICollectionViewCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (self.highlightThumbnailWhenSelected) {
        self.backgroundImageView.layer.borderWidth = selected ? 2.0 : 0.0;
        self.backgroundImageView.layer.borderColor = selected ? [UIColorFromRGB(0x1EAFFC) CGColor] : [[UIColor clearColor] CGColor];
    } else if (self.isEditing) {
        self.selectionView.selected = selected;
    }
}

#pragma mark - Public methods

- (void)configureWithMediaItem:(id<CLFMediaItemInterface>)mediaItem {
    self.backgroundImageView.image = mediaItem.thumbnail;

    if ([mediaItem isMemberOfClass:CLFVideoItem.class]) {
        self.playView.hidden = NO;
        self.timeLabel.hidden = NO;

        self.timeLabel.text = @"2:31";
    } else {
        self.playView.hidden = YES;
        self.timeLabel.hidden = YES;
    }
}

- (void)setEditing:(BOOL)editing {
    [self willChangeValueForKey:@"editing"];
    _editing = editing;
    [self didChangeValueForKey:@"editing"];
    self.selectionView.hidden = !editing;
}

@end