/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFMediaItemsSupplementaryView.h"
#import "CLFMacros.h"

@interface CLFMediaItemsSupplementaryView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation


CLFMediaItemsSupplementaryView

#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12.0f];
    self.titleLabel.textColor = UIColorFromRGB(0x818485);
}

#pragma mark - Public methods

@dynamic title;

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end