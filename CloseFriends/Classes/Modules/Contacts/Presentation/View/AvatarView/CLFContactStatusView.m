/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFContactStatusView.h"

@interface CLFContactStatusView ()

@end

@implementation CLFContactStatusView

#pragma mark - Initialization

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
    self.layer.cornerRadius = CGRectGetWidth(self.frame)*.5;
    self.layer.masksToBounds = YES;
    
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 1.0;
    
    [self gradientLayer].startPoint = CGPointMake(0.5, 0.0);
    [self gradientLayer].endPoint = CGPointMake(0.5, 1.0);
}

#pragma mark - UIView

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)[super layer];
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

#pragma mark - Public

- (void)setGradientColors:(NSArray *)gradientColors {
    if (gradientColors) {
        NSMutableArray *CGColors = [NSMutableArray arrayWithCapacity:gradientColors.count];
        for (UIColor *color in gradientColors) {
            [CGColors addObject:(id)[color CGColor]];
        }
        
        [self gradientLayer].colors = CGColors;
    }
}

#pragma mark -

@end
