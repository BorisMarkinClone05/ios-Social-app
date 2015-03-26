/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFCountryCell.h"

@interface CLFCountryCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dialCodeLabel;

@end

@implementation CLFCountryCell

#pragma mark - Public methods

@dynamic name;

- (void)setName:(NSString *)name {
    _nameLabel.text = name;
}

- (NSString *)name {
    return _nameLabel.text;
}

@dynamic dialCode;

- (void)setDialCode:(NSString *)dialCode {
    _dialCodeLabel.text = dialCode;
}

- (NSString *)dialCode {
    return _dialCodeLabel.text;
}

@end
