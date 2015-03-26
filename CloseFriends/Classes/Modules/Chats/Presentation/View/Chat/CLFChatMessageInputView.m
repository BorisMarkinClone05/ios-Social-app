/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChatMessageInputView.h"
#import "CLFMacros.h"

@interface CLFChatMessageInputView ()

@property (weak, nonatomic) IBOutlet UIView *leftContainer;
@property (weak, nonatomic) IBOutlet UIView *inputContainer;
@property (weak, nonatomic) IBOutlet UIView *rightContainer;

@end

@implementation CLFChatMessageInputView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self configure];
    }
    
    return self;
}

- (void)configure
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                  owner:self
                                                options:nil];
    UIView *view = nibs[0];
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    self.leftContainer.backgroundColor = [UIColor clearColor];
    self.inputContainer.backgroundColor = [UIColor clearColor];
    self.rightContainer.backgroundColor = [UIColor clearColor];
}

#pragma mark - Public methods

- (void)setLeftView:(UIButton *)leftView
{
    if (leftView)
    {
        [self.leftContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self addView:leftView inContainer:self.leftContainer];
    }
}

- (void)setInputView:(UIView *)inputView
{
    if (inputView)
    {
        [self.inputContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self addView:inputView inContainer:self.inputContainer];
    }
}

- (void)setRightViews:(NSArray *)rightViews
{
    if (rightViews)
    {
        [self.rightContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        if (rightViews.count == 1)
        {
            [self addView:rightViews[0] inContainer:self.rightContainer];
        }
        else if (rightViews.count == 2)
        {
            UIView *view1 = rightViews[0];
            UIView *view2 = rightViews[1];
            
            [self.rightContainer addSubview:view1];
            [self.rightContainer addSubview:view2];
            
            NSDictionary *views = NSDictionaryOfVariableBindings(view1, view2);
            view1.translatesAutoresizingMaskIntoConstraints = NO;
            view2.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.rightContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view1][view2]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
            [self.rightContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view1(==view2)]"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
            [self.rightContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view1]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
            [self.rightContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view2]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
        }
    }
}

#pragma mark - Private

- (void)addView:(UIView *)view inContainer:(UIView *)container
{
    if (view && container)
    {
        [container addSubview:view];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
    }
}




@end
