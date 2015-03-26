/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>

@protocol CLFContactInterface;

@interface CLFContactCell : UITableViewCell

- (void)configureWithContact:(id<CLFContactInterface>)contact;

@end
