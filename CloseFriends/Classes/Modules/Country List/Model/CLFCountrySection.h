/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>

@class CLFCountry;

@interface CLFCountrySection : NSObject

@property (nonatomic, readonly) NSArray *countries;
@property (nonatomic, readonly) NSString *sectionTitle;

+ (instancetype)countrySectionWithCountries:(NSArray *)countries
                               sectionTitle:(NSString *)sectionTitle;

@end
