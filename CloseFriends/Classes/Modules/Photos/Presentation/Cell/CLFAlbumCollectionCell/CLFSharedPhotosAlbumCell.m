/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFSharedPhotosAlbumCell.h"
#import "CLFContactsView.h"
#import "CLFContact.h"

@interface CLFSharedPhotosAlbumCell ()

@property (weak, nonatomic) IBOutlet CLFContactsView *contactView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation CLFSharedPhotosAlbumCell

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.deleteButton.hidden = YES;
}

#pragma mark - Public methods
- (void)configureWithAlbum:(id <CLFAlbumInterface>)album {
    [super configureWithAlbum:album];

    //TODO:Temp contact
    NSArray *contacts = @[[[CLFContact alloc] initWithFullName:@"Name"]];
    [self.contactView updatedContacts:contacts];
}

- (void)setEditing:(BOOL)editing {
    [super setEditing:editing];

    self.deleteButton.hidden = !editing;
}

#pragma mark - Actions

- (IBAction)deleteButtonTapped:(id)sender {
    if (self.deleteBlock) {
        _deleteBlock();
    }
}

@end