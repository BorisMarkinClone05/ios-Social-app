/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import UIKit;

@interface CLFTextFieldCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *detailTextField;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;

@end