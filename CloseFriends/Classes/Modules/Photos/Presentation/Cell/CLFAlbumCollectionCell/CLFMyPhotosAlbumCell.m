/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFMyPhotosAlbumCell.h"
#import "CLFContactsView.h"
#import "CLFAlbumInterface.h"
#import "CLFContact.h"
#import "CLFSelectionView.h"

@interface CLFMyPhotosAlbumCell ()

@property (weak, nonatomic) IBOutlet UIView *sharedView;
@property (weak, nonatomic) IBOutlet UIView *sharedWithView;
@property (weak, nonatomic) IBOutlet UILabel *sharedLabel;
@property (weak, nonatomic) IBOutlet CLFContactsView *contactsView;
@property (weak, nonatomic) IBOutlet CLFSelectionView *selectionView;

@end

@implementation CLFMyPhotosAlbumCell

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];

    self.sharedView.backgroundColor = [UIColor clearColor];
    self.sharedWithView.layer.cornerRadius = 2.0f;
    self.sharedWithView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    self.sharedLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:9.0f];
    self.sharedLabel.textColor = [UIColor whiteColor];
    self.sharedLabel.text = @"SHARED WITH";

    self.contactsView.interSpacing = 8.0f;

    self.selectionView.hidden = YES;
}

#pragma mark - UICollectionViewCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    if (self.isEditing) {
        self.selectionView.selected = selected;
    }
}

#pragma mark - Public methods

- (void)configureWithAlbum:(id<CLFAlbumInterface>)album {
    [super configureWithAlbum:album];

    //TODO:Temp contact
    NSArray *contacts = @[[[CLFContact alloc] initWithFullName:@"Name"],
                          [[CLFContact alloc] initWithFullName:@"Name"],
                          [[CLFContact alloc] initWithFullName:@"Name"],
                          [[CLFContact alloc] initWithFullName:@"Name"],
                          [[CLFContact alloc] initWithFullName:@"Name"]];
    [self.contactsView updatedContacts:contacts];
}

- (void)setEditing:(BOOL)editing {
    [super setEditing:editing];

    self.selectionView.hidden = !editing;
}


@end