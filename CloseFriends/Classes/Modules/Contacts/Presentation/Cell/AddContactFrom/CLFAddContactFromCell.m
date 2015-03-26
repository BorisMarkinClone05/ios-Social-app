/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFAddContactFromCell.h"
#import "CLFMacros.h"

@interface CLFAddContactFromCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CLFAddContactFromCell

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.label.font = [UIFont fontWithName:@"Avenir-Medium" size:15.0];
    self.label.textColor = UIColorFromRGB(0x000000);
}

#pragma mark - Public methods

@dynamic title;

- (void)setTitle:(NSString *)title {
    self.label.text = title;
}

- (NSString *)title {
    return self.label.text;
}

#pragma mark -

@end
