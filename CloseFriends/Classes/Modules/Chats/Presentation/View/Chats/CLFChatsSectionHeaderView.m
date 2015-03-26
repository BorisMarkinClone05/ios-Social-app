/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChatsSectionHeaderView.h"
#import "CLFMacros.h"
#import "CLFChatGroupInterface.h"
#import "CLFAppearanceManager.h"

@interface CLFChatsSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CLFChatsSectionHeaderView

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [[CLFAppearanceManager sharedInstance].currentTheme generalBackgroundColor];
    
    self.backgroundView = backgroundView;
    
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12.0];
    self.titleLabel.textColor = UIColorFromRGB(0x828485);
}

#pragma mark - Public

- (void)configureWithChatGroup:(id<CLFChatGroupInterface>)chatGroup {
    if (chatGroup) {
        self.titleLabel.text = chatGroup.title;
    }
}

#pragma mark -

@end
