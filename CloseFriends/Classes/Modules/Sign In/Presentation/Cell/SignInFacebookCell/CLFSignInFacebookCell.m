/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFSignInFacebookCell.h"

@interface CLFSignInFacebookCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CLFSignInFacebookCell

#pragma mark - UITableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12.0f];
}

@end