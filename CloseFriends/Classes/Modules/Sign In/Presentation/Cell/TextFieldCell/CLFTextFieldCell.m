/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFTextFieldCell.h"
#import "CLFMacros.h"

@interface CLFTextFieldCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CLFTextFieldCell

#pragma mark - UITextFieldCell
- (void)awakeFromNib {
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:15.0f];
    self.detailTextField.font = [UIFont fontWithName:@"Avenir-Medium" size:15.0f];
    self.detailTextField.textColor = UIColorFromRGB(0x8e8e93);
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (BOOL)becomeFirstResponder {
    return [self.detailTextField becomeFirstResponder];
}

#pragma mark - Public methods

@dynamic title;

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (NSString *)title{
    return self.titleLabel.text;
}

@dynamic detail;

- (void)setDetail:(NSString *)detail{
    self.detailTextField.text = detail;
}

- (NSString *)detail{
    return self.detailTextField.text;
}

@end