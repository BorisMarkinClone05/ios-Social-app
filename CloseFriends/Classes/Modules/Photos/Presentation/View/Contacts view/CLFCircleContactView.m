/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFCircleContactView.h"
#import "CLFAppearanceManager.h"

@interface CLFCircleContactView ()

@end

@implementation CLFCircleContactView

#pragma mark - Initialization

- (instancetype)init {
    if (self = [super init]) {
        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization {

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:imageView];
    _imageView = imageView;

    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:label];
    _label = label;

    _label.font = [UIFont fontWithName:@"Avenir-Roman" size:18.0f];
    _label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
    _label.textAlignment = NSTextAlignmentCenter;

    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.clipsToBounds = YES;

    self.backgroundColor = [[[CLFAppearanceManager sharedInstance] currentTheme] navigationBarBarTintColor];

    [self setNeedsUpdateConstraints];
}

#pragma mark - UIView

- (void)updateConstraints {
    NSDictionary *viewsDictionary = @{@"image":self.imageView};
    NSArray *vImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[image]-0-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictionary];
    NSArray *hImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[image]-0-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictionary];
    [self addConstraints:vImageConstraints];
    [self addConstraints:hImageConstraints];

    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.layer.cornerRadius = self.bounds.size.height / 2.0f;
}

#pragma mark - Private methods

@end