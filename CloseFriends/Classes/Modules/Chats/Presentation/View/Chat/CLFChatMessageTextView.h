/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import UIKit;

@interface CLFChatMessageTextView : UITextView

@property (nonatomic, assign) CGFloat minimumHeight;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@end
