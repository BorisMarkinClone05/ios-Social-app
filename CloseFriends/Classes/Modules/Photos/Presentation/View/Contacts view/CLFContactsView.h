/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

@interface CLFContactsView : UIView

@property (nonatomic) CGFloat interSpacing;
@property (nonatomic) CGFloat sideSize; //0 for calculating dynamically
@property (nonatomic) NSUInteger maxNumberOfVisibleContacts;  //0 for displaying all contacts
@property (nonatomic, readonly) NSArray *contacts;

- (void)updatedContacts:(NSArray *)contacts;

@end