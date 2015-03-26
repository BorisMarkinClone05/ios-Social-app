/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFSignInCountryCell.h"
#import "UIDevice+OSVersion.h"

@interface CLFSignInCountryCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countyNameLabel;

@end

@implementation CLFSignInCountryCell

#pragma mark - UITableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];

    UIColor *textColor = [UIColor whiteColor];
    CGFloat fontSize = 15.0f;
    NSString *fontName = @"AvenirNext-Regular";

    _titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
    _titleLabel.textColor = textColor;

    _countyNameLabel.font = [UIFont fontWithName:fontName size:fontSize];
    _countyNameLabel.textColor = textColor;

    CGFloat alpha = 0.2f;
    if ([UIDevice isiOS8AndEarlier]) {
        alpha += 0.1f;
    }
    self.backgroundColor  = [UIColor colorWithRed:1.0f
                                            green:1.0f
                                             blue:1.0f
                                            alpha:alpha];
}

#pragma mark - Public methods

@dynamic countryName;

- (void)setCountryName:(NSString *)name {
    _countyNameLabel.text = name;
}

- (NSString *)countryName {
    return _countyNameLabel.text;
}

@dynamic title;

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (NSString *)title {
    return _titleLabel.text;
}

@end