/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFContactAvatarView.h"
#import "CLFContactInterface.h"
#import "CLFMacros.h"
#import "CLFContactStatusView.h"

@interface CLFContactAvatarView ()

@property (weak, nonatomic) IBOutlet CLFContactStatusView *statusView;

@end

@implementation CLFContactAvatarView


#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self
                                                    options:nil] firstObject];
        view.frame = self.bounds;
        [self addSubview:view];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self
                                                    options:nil] firstObject];
        [self addSubview:view];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.frame)*0.5;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
}

#pragma mark - Public 

- (void)configureWithContact:(id<CLFContactInterface>)contact {
    if (contact) {
        self.statusView.gradientColors = [self statusGradientColorsForStatus:contact.status];
    }
}

- (void)setStatusViewHidden:(BOOL)statusViewHidden {
    self.statusView.hidden = statusViewHidden;
}

#pragma mark - Helper methods

- (NSArray *)statusGradientColorsForStatus:(CLFContactStatus)status {
    NSArray *colors = nil;
    
    switch (status)
    {
        case CLFContactStatusAvailable:
            colors = @[UIColorFromRGB(0x82EC82), UIColorFromRGB(0x17DB17)];
            break;
        
        case CLFContactStatusAway:
            colors = @[UIColorFromRGB(0xEC8282), UIColorFromRGB(0xDB1717)];
            break;
            
        case CLFContactStatusBusy:
            colors = @[UIColorFromRGB(0xECC382), UIColorFromRGB(0xDB8E17)];
            break;
            
        default:
            break;
    }
    
    return colors;
}

#pragma mark -

@end
