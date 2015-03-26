/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChatMessageTextView.h"
#import "CLFMacros.h"

@interface CLFChatMessageTextView ()

@property (nonatomic, assign) CGFloat currentHeight;

@end


@implementation CLFChatMessageTextView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self configureTextView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self configureTextView];
    }
    
    return self;
}

- (void)configureTextView
{
    [self startToObserveStateChangedNotifications];
    
    self.placeholderColor = [UIColor lightGrayColor];
    
    self.layer.cornerRadius = 6.0;
    self.layer.borderColor = [UIColorFromRGB(0xC8C8CD) CGColor];
    self.layer.borderWidth = 1.0;
    self.layer.masksToBounds = YES;
    
    self.contentMode = UIViewContentModeRedraw;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.textContainerInset = UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0);
    
    self.scrollEnabled = NO;
}

#pragma mark - Deallocation

- (void)dealloc
{
    [self stopToObserveStateChangedNotifications];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [self sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds),
                                                MAXFLOAT)];
    
    if (size.height != _currentHeight)
    {
        _currentHeight = MAX(size.height, _minimumHeight);
        
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(CGRectGetWidth(self.bounds),
                      _currentHeight);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.text.length == 0 && self.placeholder)
    {
        [self.placeholderColor set];
        [self.placeholder drawInRect:CGRectInset(rect, 8.0, 4.0)
                      withAttributes:[self placeholderAttributes]];
    }
}

#pragma mark - State changed notifications

- (void)startToObserveStateChangedNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateChangedNotificationReceived:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateChangedNotificationReceived:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateChangedNotificationReceived:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:self];
}

- (void)stopToObserveStateChangedNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:nil];
}

- (void)stateChangedNotificationReceived:(NSNotification *)notification
{
    NSString *notificationName = notification.name;
    
    if ([notificationName isEqualToString:UITextViewTextDidBeginEditingNotification] ||
        [notificationName isEqualToString:UITextViewTextDidEndEditingNotification])
    {
        [self setNeedsDisplay];
    }
    else if ([notificationName isEqualToString:UITextViewTextDidChangeNotification])
    {
        [self setNeedsDisplay];
        [self setNeedsLayout];
    }
}

#pragma mark - Placeholder

- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder != _placeholder)
    {
        _placeholder = [placeholder copy];
        
        [self setNeedsDisplay];
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    if (placeholderColor != _placeholderColor)
    {
        _placeholderColor = placeholderColor;
        
        [self setNeedsDisplay];
    }
}

- (NSDictionary *)placeholderAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = self.textAlignment;
    
    return @{ NSFontAttributeName : self.font,
              NSForegroundColorAttributeName : self.placeholderColor,
              NSParagraphStyleAttributeName : paragraphStyle };
}

#pragma mark -

@end
