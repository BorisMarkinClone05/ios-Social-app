/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>

@protocol CLFContactGroupInterface;

@protocol CLFContactsSectionHeaderViewDelegate;

@interface CLFContactsSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) id<CLFContactGroupInterface> contactGroup;
@property (nonatomic, weak) id<CLFContactsSectionHeaderViewDelegate> delegate;

+ (instancetype)view;

- (void)configureWithContactGroup:(id<CLFContactGroupInterface>)contactGroup;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end

@protocol CLFContactsSectionHeaderViewDelegate <NSObject>

@optional

- (void)contactsSectionHeaderEditGroupButtonTapped:(CLFContactsSectionHeaderView *)sectionHeader;

@end
