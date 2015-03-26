/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFPhotoViewController.h"
#import "CLFMediaItemInterface.h"
#import "CLFPhotoScrollView.h"

@interface CLFPhotoViewController ()

@property (weak, nonatomic) IBOutlet CLFPhotoScrollView *photoScrollView;

@end

@implementation CLFPhotoViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.mediaItem) {
        self.photoScrollView.photo = self.mediaItem.thumbnail;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.photoScrollView.frame = self.view.bounds;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.photoScrollView resetZoom];
}

#pragma mark - Public

- (void)setMediaItem:(id<CLFMediaItemInterface>)mediaItem {
    if (mediaItem != _mediaItem) {
        _mediaItem = mediaItem;
        
        if (self.photoScrollView) {
            self.photoScrollView.photo = mediaItem.thumbnail;
        }
    }
}

#pragma mark -

@end
