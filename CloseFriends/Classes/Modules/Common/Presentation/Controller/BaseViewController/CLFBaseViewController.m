/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFBaseViewController.h"
#import "CLFMacros.h"

#import "UIViewController+StatusBarAppearance.h"

@interface CLFBaseViewController ()

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation CLFBaseViewController

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        [self initializeTitleLabel];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeTitleLabel];
    }
    
    return self;
}

- (void)initializeTitleLabel {
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    
    self.navigationItem.titleView = titleLabel;
    self.titleLabel = titleLabel;
}

#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self defaultPreferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    return [self defaultPrefersStatusBarHidden];
}

#pragma mark - Public

- (void)setDetailTitle:(NSString *)detailTitle {
    if (detailTitle != _detailTitle) {
        _detailTitle = [detailTitle copy];
        
        [self setTitleLabelTextWithTitle:self.title
                            detailtTitle:self.detailTitle];
    }
}

- (void)setTitle:(NSString *)title {
    if (title != [super title]) {
        [super setTitle:title];
        
        [self setTitleLabelTextWithTitle:title
                            detailtTitle:self.detailTitle];
    }
}

#pragma mark - Private

- (void)setTitleLabelTextWithTitle:(NSString *)title detailtTitle:(NSString *)detailTitle {
    NSMutableAttributedString *attributedCombinedTitle = [NSMutableAttributedString new];
    
    if (title.length > 0) {
        UIFont *titleFont = self.titleFont ?: [UIFont fontWithName:@"AvenirNext-Regular" size:15.0];
        UIColor *titleColor = self.titleColor ?: [UIColor whiteColor];
        
        NSAttributedString * attributedTitle = [[NSAttributedString alloc] initWithString:title
                                                                               attributes:@{
                                                                                            NSFontAttributeName : titleFont,
                                                                                            NSForegroundColorAttributeName : titleColor
                                                                                            }];
        [attributedCombinedTitle appendAttributedString:attributedTitle];
    }
    
    if (title.length > 0 && detailTitle.length > 0) {
        [attributedCombinedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    
    if (detailTitle.length > 0) {
        UIFont *detailFont = self.detailTitleFont ?: [UIFont fontWithName:@"AvenirNext-DemiBold" size:9.0];
        UIColor *detailColor = self.detailTitleColor ?: [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        
        NSAttributedString *attributedDetailTitle = [[NSAttributedString alloc] initWithString:detailTitle
                                                                                    attributes:@{
                                                                                                 NSFontAttributeName : detailFont,
                                                                                                 NSForegroundColorAttributeName : detailColor
                                                                                                 }];
        [attributedCombinedTitle appendAttributedString:attributedDetailTitle];
    }
    
    self.titleLabel.attributedText = attributedCombinedTitle;
    [self.titleLabel sizeToFit];
}

#pragma mark -

@end
