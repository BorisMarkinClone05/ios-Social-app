/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFContactCell.h"
#import "CLFMacros.h"
#import "CLFContactInterface.h"
#import "CLFContactAvatarView.h"

@interface CLFContactCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet CLFContactAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *chevron;

@end

@implementation CLFContactCell

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.font = [UIFont fontWithName:@"Avenir-Book" size:15.0];
    self.nameLabel.textColor = [UIColor blackColor];
    
    self.statusLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12.0];
    self.statusLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
}

#pragma mark - UITableViewCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.chevron.hidden = editing;
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

#pragma mark - Public

- (void)configureWithContact:(id<CLFContactInterface>)contact {
    if (contact) {
        self.nameLabel.text = [contact fullName];
        self.statusLabel.text = [contact statusAsString];
        [self.avatarView configureWithContact:contact];
    }
}

#pragma mark -

@end
