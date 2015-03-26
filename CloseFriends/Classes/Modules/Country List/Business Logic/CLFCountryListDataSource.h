/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>

@class CLFCountry;

@interface CLFCountryListDataSource : NSObject

@property (nonatomic, readonly) NSArray *sections; //Array of CLFCountrySection

- (void)filterCountriesByName:(NSString *)name;

- (CLFCountry *)countryByDialCode:(NSString *)dialCode;

@end
