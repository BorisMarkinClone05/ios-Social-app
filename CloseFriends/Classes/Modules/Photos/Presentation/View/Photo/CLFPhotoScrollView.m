/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFPhotoScrollView.h"

@interface CLFPhotoScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *zoomView;

@property (nonatomic) CGPoint pointToCenterAfterResize;
@property (nonatomic) CGFloat scaleToRestoreAfterResize;

@end

@implementation CLFPhotoScrollView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInitialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization {
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    self.zoomView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.zoomView];
}

#pragma mark - Public

- (void)setPhoto:(UIImage *)photo {
    if (photo != _photo) {
        _photo = photo;
        
        if (_photo) {
            [self displayImage:_photo];
        }
        
        [self setNeedsLayout];
    }
}

- (void)resetZoom {
    self.zoomScale = self.minimumZoomScale;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.zoomView.frame;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    
    self.zoomView.frame = frameToCenter;
}

- (void)setFrame:(CGRect)frame
{
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if (sizeChanging)
    {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if (sizeChanging)
    {
        [self recoverFromResizing];
    }
}

#pragma mark - Private

- (void)displayImage:(UIImage *)image {
    [self.zoomView removeFromSuperview];
    self.zoomView = nil;
    
    self.zoomScale = 1.0;
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 1.0;
    
    self.zoomView = [[UIImageView alloc] initWithImage:image];
    self.zoomView.frame = (CGRect){.origin = CGPointZero, .size = image.size};
    self.zoomView.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:self.zoomView];
    
    [self configureForImageSize:image.size];
}

- (void)configureForImageSize:(CGSize)imageSize {
    self.contentSize = imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    CGSize boundsSize = self.bounds.size;
    
    CGFloat xScale = boundsSize.width  / _photo.size.width;
    CGFloat yScale = boundsSize.height / _photo.size.height;
    
    CGFloat minScale = MIN(xScale, yScale);
    CGFloat maxScale = 2.0 / [[UIScreen mainScreen] scale];
    
    if (minScale > maxScale)
    {
        if (![self isScalableImageWithSize:_photo.size])
        {
            minScale = maxScale;
        }
        
        maxScale = 2 * minScale;
    }
    
    if (minScale > 0.0 && maxScale > 0.0)
    {
        self.maximumZoomScale = maxScale;
        self.minimumZoomScale = minScale;
    }
    else
    {
        self.maximumZoomScale = 1.0;
        self.minimumZoomScale = 0.5;
    }
}

- (BOOL)isScalableImageWithSize:(CGSize)imageSize {
    CGSize boundsSize = self.bounds.size;
    return boundsSize.width/imageSize.width < 4 && boundsSize.height/imageSize.height < 4;
}

- (void)prepareToResize
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:_zoomView];
    
    _scaleToRestoreAfterResize = self.zoomScale;
    
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing
{
    [self setMaxMinZoomScalesForCurrentBounds];
    
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:_zoomView];
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.zoomView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark -

@end
