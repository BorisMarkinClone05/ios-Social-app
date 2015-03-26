/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFMyPhotosViewController.h"
#import "CLFMyPhotosAdapter.h"
#import "CLFAlbum.h"
#import "CLFPhotoAlbumViewController.h"
#import "CLFMacros.h"

@interface CLFMyPhotosViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIButton *sendToButton;
@property (weak, nonatomic) IBOutlet UIButton *addToAlbumButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (nonatomic, strong) CLFMyPhotosAdapter *myPhotosAdapter;

@end

@implementation CLFMyPhotosViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupEditView];

    self.collectionView.allowsMultipleSelection = YES;
    self.myPhotosAdapter = [[CLFMyPhotosAdapter alloc] initWithCollectionView:self.collectionView
                                                                     sections:self.myPhotosSections];
    __weak typeof(self) weakSelf = self;
    self.myPhotosAdapter.didChangedSelectedItemsBlock = ^(NSArray *selectedItems) {
        if (weakSelf.selectedItemsHandler) {
            weakSelf.selectedItemsHandler(selectedItems);
        }
    };

    self.myPhotosAdapter.didSelectItemBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        if (indexPath.section == 0) {
            CLFPhotoAlbumViewController *albumVC = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CLFPhotoAlbumViewController class])];
            albumVC.hidesBottomBarWhenPushed = YES;
            [albumVC setAlbum:weakSelf.myPhotosSections[indexPath.section][indexPath.item]
                    mediaItem:nil];
            
            [weakSelf.navigationController pushViewController:albumVC
                                                     animated:YES];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.editing) {
        self.tabBarController.tabBar.hidden = YES;
        self.editView.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.editing) {
        self.tabBarController.tabBar.hidden = NO;
        self.editView.hidden = YES;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Public methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    if (editing) {
        self.tabBarController.tabBar.hidden = YES;
        self.editView.hidden = NO;
    } else {
        self.tabBarController.tabBar.hidden = NO;
        self.editView.hidden = YES;
    }

    [self.myPhotosAdapter updateContentForEditing:editing];
}

#pragma mark - Private methods

- (void)setupEditView {
    self.editView.hidden = YES;

    [self.sendToButton setTitleColor:UIColorFromRGB(0x3FA7E5) forState:UIControlStateNormal];
    [self.sendToButton setTitleColor:[UIColorFromRGB(0x3FA7E5) colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    self.sendToButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
    [self.sendToButton setTitle:@"Send To" forState:UIControlStateNormal];

    [self.addToAlbumButton setTitleColor:UIColorFromRGB(0x3FA7E5) forState:UIControlStateNormal];
    [self.addToAlbumButton setTitleColor:[UIColorFromRGB(0x3FA7E5) colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    self.addToAlbumButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
    [self.addToAlbumButton setTitle:@"Add To Album" forState:UIControlStateNormal];

    [self.removeButton setTitleColor:UIColorFromRGB(0xE0000E) forState:UIControlStateNormal];
    [self.removeButton setTitleColor:[UIColorFromRGB(0xE0000E) colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    self.removeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
    [self.removeButton setTitle:@"Remove" forState:UIControlStateNormal];
}

@end