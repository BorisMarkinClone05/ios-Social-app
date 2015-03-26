/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFContactsAdapter.h"
#import "CLFContactCell.h"
#import "CLFContactsSectionHeaderView.h"
#import "CLFAddContactCell.h"

#import "CLFContactGroup.h"
#import "CLFContact.h"

static NSString * const ContactCellIdentifier = @"CLFContactCell";
static NSString * const AddContactCellIdentifier = @"CLFAddContactCell";
static NSString * const ContactsSectionHeaderIdentifier = @"CLFContactsSectionHeaderView";

@interface CLFContactsAdapter ()

@property (nonatomic, strong) NSArray *contactGroups;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CLFContactsAdapter

#pragma mark - Initialization

- (instancetype)initWithTableView:(UITableView *)tableView
                    contactGroups:(NSArray *)contactGroups {
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFContactCell class])
                                                       bundle:nil]
             forCellReuseIdentifier:ContactCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFAddContactCell class])
                                                   bundle:nil]
             forCellReuseIdentifier:AddContactCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFContactsSectionHeaderView class])
                                                   bundle:nil] forHeaderFooterViewReuseIdentifier:ContactsSectionHeaderIdentifier];
        
        self.tableView.tableFooterView = [UIView new];
        self.tableView.allowsSelectionDuringEditing = YES;
        
        self.contactGroups = contactGroups;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *groupContacts = [self.contactGroups[section] contacts];
    return groupContacts.count + (int)tableView.editing;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    
    NSArray *groupContacts = [self.contactGroups[indexPath.section] contacts];
    if ([self isAddContactIndexPath:indexPath]) {
        CLFAddContactCell *cell = (CLFAddContactCell *)[tableView dequeueReusableCellWithIdentifier:AddContactCellIdentifier
                                                                                       forIndexPath:indexPath];
        result = cell;
    }
    else {
        CLFContactCell *cell = (CLFContactCell *)[tableView dequeueReusableCellWithIdentifier:ContactCellIdentifier
                                                                                 forIndexPath:indexPath];
        [cell configureWithContact:groupContacts[indexPath.row]];
        
        result = cell;
    }
    
    return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contactGroups.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![self isAddContactIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![self isAddContactIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CLFContactsSectionHeaderView *header = (CLFContactsSectionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:ContactsSectionHeaderIdentifier];
    [header configureWithContactGroup:self.contactGroups[section]];
    [header setEditing:tableView.editing animated:NO];
    header.delegate = self.sectionHeaderDelegate;
    
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return [self isAddContactIndexPath:proposedDestinationIndexPath] ? sourceIndexPath : proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(tableView, indexPath);
    }
}

#pragma mark - Helper methods

- (BOOL)isAddContactIndexPath:(NSIndexPath *)indexPath {
    BOOL result = NO;
    
    if (indexPath && self.tableView.editing) {
        NSArray *groupContacts = [self.contactGroups[indexPath.section] contacts];
        result = indexPath.row == groupContacts.count;
    }
    
    return result;
}

#pragma mark -

@end
