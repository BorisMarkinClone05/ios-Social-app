/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFPhotoActionView.h"
#import "CLFContactsView.h"

@interface CLFPhotoActionView ()

@property (weak, nonatomic) IBOutlet CLFContactsView *contactsView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end

@implementation CLFPhotoActionView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configure];
    }
    return self;
}

- (void)configure {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                  owner:self
                                                options:nil];
    UIView *view = nibs[0];
    view.backgroundColor = [UIColor clearColor];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contactsView.sideSize = 40.0;
    self.contactsView.interSpacing = 8.0;
    self.contactsView.maxNumberOfVisibleContacts = 0;
}

#pragma mark - Public

- (void)configureWithMediaItem:(id<CLFMediaItemInterface>)mediaItem {
    
}

#pragma mark -

@end
