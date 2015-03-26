/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>

@interface CLFBaseViewController : UIViewController

@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, strong) UIFont *detailTitleFont;
@property (nonatomic, strong) UIColor *detailTitleColor;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

@end
