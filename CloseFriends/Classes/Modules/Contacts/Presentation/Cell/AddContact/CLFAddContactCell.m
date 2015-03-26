/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFAddContactCell.h"
#import "CLFContactAvatarView.h"
#import "CLFMacros.h"

@interface CLFAddContactCell ()

@property (weak, nonatomic) IBOutlet CLFContactAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CLFAddContactCell

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.label.font = [UIFont fontWithName:@"Avenir-Book" size:15.0];
    self.label.textColor = UIColorFromRGB(0x000000);
}

#pragma mark -

@end
