/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFSelectionView.h"
#import "CLFMacros.h"

@interface CLFSelectionView ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation CLFSelectionView

#pragma mark  - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteCheckMark"]];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:imageView];
    _imageView = imageView;

    self.layer.cornerRadius = 11.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;

    [self updatedForSelectedState];

    [self setNeedsUpdateConstraints];
}

#pragma mark - UIView

- (void)updateConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [super updateConstraints];
}

#pragma mark - Public methods

- (void)setSelected:(BOOL)selected {
    [self willChangeValueForKey:@"selected"];
    _selected = selected;
    [self didChangeValueForKey:@"selected"];
    [self updatedForSelectedState];
}

#pragma mark - Private methods

- (void)updatedForSelectedState {
    if (self.isSelected) {
        self.backgroundColor = UIColorFromRGB(0x00ADE3);
        self.imageView.hidden = NO;
    } else {
        self.backgroundColor = [UIColorFromRGB(0xF8F8F8) colorWithAlphaComponent:0.5f];
        self.imageView.hidden = YES;
    }
}


@end