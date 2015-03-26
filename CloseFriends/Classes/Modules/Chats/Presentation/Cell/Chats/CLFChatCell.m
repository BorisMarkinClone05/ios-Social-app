/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChatCell.h"
#import "CLFContactAvatarView.h"
#import "CLFChatInterface.h"
#import "CLFContactInterface.h"

@interface CLFChatCell ()

@property (weak, nonatomic) IBOutlet CLFContactAvatarView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chevron;

@end

@implementation CLFChatCell

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contactNameLabel.font = [UIFont fontWithName:@"Avenir-Book" size:15.0];
    self.contactNameLabel.textColor = [UIColor blackColor];
    
    self.lastMessageLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12.0];
    self.lastMessageLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
}

#pragma mark - UITableViewCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.chevron.hidden = editing;
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

#pragma mark - Public methods

- (void)configureWithChat:(id<CLFChatInterface>)chat {
    if (chat) {
        self.contactNameLabel.text = chat.contact.fullName;
        self.lastMessageLabel.text = chat.lastMessage;
        [self.avatar configureWithContact:chat.contact];
    }
}

#pragma mark -

@end
