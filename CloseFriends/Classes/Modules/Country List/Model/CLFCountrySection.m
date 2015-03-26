/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFCountrySection.h"

@implementation CLFCountrySection

#pragma mark - Initialization

+ (instancetype)countrySectionWithCountries:(NSArray *)countries
                               sectionTitle:(NSString *)sectionTitle {
    return [[self alloc] initWithCountries:countries
                              sectionTitle:sectionTitle];
}

- (instancetype)initWithCountries:(NSArray *)countries
                     sectionTitle:(NSString *)sectionTitle {
    self = [super init];
    if (self) {
        _countries = [countries copy];
        _sectionTitle = [sectionTitle copy];
    }
    
    return self;
}

@end
