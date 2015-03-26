/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFContactsSectionHeaderView.h"
#import "CLFMacros.h"

#import "CLFAppearanceManager.h"

#import "CLFContactGroupInterface.h"

@interface CLFContactsSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *editGroupButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTrailingContraint;
@property (nonatomic) CGFloat titleDefaultTrailing;
@property (nonatomic) BOOL editing;

@end

@implementation CLFContactsSectionHeaderView

#pragma mark - Initialization

+ (instancetype)view {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                         owner:nil
                                       options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [[CLFAppearanceManager sharedInstance].currentTheme generalBackgroundColor];
    
    self.backgroundView = backgroundView;
    
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12.0];
    self.titleLabel.textColor = UIColorFromRGB(0x828485);
    
    self.editGroupButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:11.0];
    [self.editGroupButton setTitleColor:UIColorFromRGB(0x00AAE7)
                               forState:UIControlStateNormal];
    
    self.editGroupButton.alpha = 0.0;
    self.editGroupButton.hidden = YES;
    
    self.titleDefaultTrailing = self.titleTrailingContraint.constant;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat titleTrailing = self.titleDefaultTrailing;
    if (self.editing) {
        titleTrailing = CGRectGetWidth(self.bounds) - CGRectGetMinX(self.editGroupButton.frame) + self.titleDefaultTrailing;
    }
    
    if (titleTrailing != self.titleTrailingContraint.constant) {
        self.titleTrailingContraint.constant = titleTrailing;
        
        [super layoutSubviews];
    }
}

#pragma mark - Public methods

- (void)configureWithContactGroup:(id<CLFContactGroupInterface>)contactGroup {
    self.contactGroup = contactGroup;
    self.titleLabel.text = [contactGroup name];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (editing == self.editing) {
        return;
    }
    
    _editing = editing;
    
    if (editing) {
        self.editGroupButton.hidden = NO;
        self.editGroupButton.alpha = 0.0;
    }
    
    CGFloat titleTrailing = self.titleDefaultTrailing;
    if (self.editing) {
        titleTrailing = CGRectGetWidth(self.bounds) - CGRectGetMinX(self.editGroupButton.frame) + self.titleDefaultTrailing;
    }
    
    if (titleTrailing != self.titleTrailingContraint.constant) {
        self.titleTrailingContraint.constant = titleTrailing;
    }
    
    [UIView animateWithDuration:0.25*animated
                     animations:^{
                         self.editGroupButton.alpha = editing ? 1.0 : 0.0;
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (!editing) {
                             self.editGroupButton.hidden = YES;
                         }
                     }];
}

#pragma mark - Actions

- (IBAction)editGroupButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(contactsSectionHeaderEditGroupButtonTapped:)]) {
        [self.delegate contactsSectionHeaderEditGroupButtonTapped:self];
    }
}

#pragma mark -

@end
