/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>

@class CLFCountry;
@class CLFCountryListDataSource;

@interface CLFCountryPickerViewController : UITableViewController

@property (nonatomic, strong) CLFCountryListDataSource *countryListDataSource;
@property (nonatomic, copy) void (^completionHandler)(CLFCountry *selectedCountry);

@end
