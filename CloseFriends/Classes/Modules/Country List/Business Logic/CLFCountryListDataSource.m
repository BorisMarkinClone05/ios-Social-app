/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFCountryListDataSource.h"
#import "CLFCountry.h"
#import "CLFCountrySection.h"

@interface CLFCountryListDataSource ()

@property (nonatomic, strong) NSArray *allCountries;
@property (nonatomic, strong) NSArray *allCountriesGroupedByFirstLetter;

@end

@implementation CLFCountryListDataSource

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        NSData *json = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries"
                                                                                      ofType:@"json"]];
        
        id countries = [NSJSONSerialization JSONObjectWithData:json
                                                       options:0
                                                         error:nil];
        if ([countries isKindOfClass:[NSArray class]]) {
            NSMutableArray *allCountries = [NSMutableArray new];
            NSMutableArray *allCountriesGroupedByFirstLetter = [NSMutableArray new];
            NSMutableArray *currentSectionCountries = [NSMutableArray new];
            NSString *currentSectionFirstLetter = nil;
            
            for (NSDictionary *countryDictionary in countries) {
                CLFCountry *country = [CLFCountry countryWithName:countryDictionary[@"name"]
                                                             code:countryDictionary[@"code"]
                                                         dialCode:countryDictionary[@"dial_code"]];
                [allCountries addObject:country];
                
                NSString *firstLetter = [country.name substringToIndex:1];
                
                if (currentSectionFirstLetter != nil &&
                    ![currentSectionFirstLetter isEqualToString:firstLetter]) {
                    CLFCountrySection *section = [CLFCountrySection countrySectionWithCountries:currentSectionCountries
                                                                                   sectionTitle:currentSectionFirstLetter];
                    [allCountriesGroupedByFirstLetter addObject:section];
                    [currentSectionCountries removeAllObjects];
                }
                
                currentSectionFirstLetter = firstLetter;
                [currentSectionCountries addObject:country];
            }
            
            CLFCountrySection *section = [CLFCountrySection countrySectionWithCountries:currentSectionCountries
                                                                           sectionTitle:currentSectionFirstLetter];
            [allCountriesGroupedByFirstLetter addObject:section];
            
            _allCountries = [allCountries copy];
            _allCountriesGroupedByFirstLetter = [allCountriesGroupedByFirstLetter copy];
            _sections = _allCountriesGroupedByFirstLetter;
        }
    }
    
    return self;
}

#pragma mark - Public methods

- (void)filterCountriesByName:(NSString *)name {
    if (name.length == 0) {
        _sections = _allCountriesGroupedByFirstLetter;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", name];
        NSArray *filteredCountries = [_allCountries filteredArrayUsingPredicate:predicate];
        
        CLFCountrySection *section = [CLFCountrySection countrySectionWithCountries:filteredCountries
                                                                       sectionTitle:nil];
        
        _sections = @[section];
    }
}

- (CLFCountry *)countryByDialCode:(NSString *)dialCode {
    CLFCountry *result = nil;
    
    if (dialCode.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.dialCode == %@", dialCode];
        
        NSArray *filteredCountries = [_allCountries filteredArrayUsingPredicate:predicate];
        if (filteredCountries.count > 0) {
            result = filteredCountries[0];
        }
    }
    
    return result;
}

@end
