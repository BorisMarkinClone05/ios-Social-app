/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFSharedPhotosViewController.h"
#import "CLFSharedPhotosAdapter.h"

@interface CLFSharedPhotosViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) CLFSharedPhotosAdapter *sharedPhotosAdapter;

@end

@implementation CLFSharedPhotosViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sharedPhotosAdapter = [[CLFSharedPhotosAdapter alloc] initWithCollectionView:self.collectionView
                                                                               albums:self.sharedAlbums];
    if (self.isEditing) {
        [self.sharedPhotosAdapter updateContentForEditing:self.isEditing];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Public methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    [self.sharedPhotosAdapter updateContentForEditing:editing];
}

@end