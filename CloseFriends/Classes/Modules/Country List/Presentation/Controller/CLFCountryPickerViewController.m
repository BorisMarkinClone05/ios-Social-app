/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFCountryPickerViewController.h"

//Presentation
#import "CLFCountryCell.h"

//Business Logic
#import "CLFCountryListDataSource.h"

//Model
#import "CLFCountry.h"
#import "CLFCountrySection.h"

//Helper
#import "UIDevice+OSVersion.h"
#import "UIViewController+StatusBarAppearance.h"

static NSString * const CLFCountryCellIdentifier = @"CLFCountryCell";

@interface CLFCountryPickerViewController ()
<
UISearchDisplayDelegate,
UISearchResultsUpdating
>

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayController;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation CLFCountryPickerViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:CLFCountryCellIdentifier
                                               bundle:nil]
         forCellReuseIdentifier:CLFCountryCellIdentifier];
    
    if ([UIDevice isiOS8AndEarlier]) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        [_searchController.searchBar sizeToFit];
        _searchController.dimsBackgroundDuringPresentation = NO;
        
        self.tableView.tableHeaderView = _searchController.searchBar;
        _searchController.searchBar.placeholder = @"Search";
        
        self.definesPresentationContext = YES;
    } else {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0,
                                                                               0.0,
                                                                               CGRectGetWidth(self.tableView.frame),
                                                                               44.0)];
        searchBar.placeholder = @"Search";
        self.tableView.tableHeaderView = searchBar;
        _searchBar = searchBar;
        
        _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar
                                                               contentsController:self];
        _displayController.delegate = self;
        _displayController.searchResultsDataSource = self;
        _displayController.searchResultsDelegate = self;
        [_displayController.searchResultsTableView registerNib:[UINib nibWithNibName:CLFCountryCellIdentifier
                                                                                   bundle:nil]
                                        forCellReuseIdentifier:CLFCountryCellIdentifier];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self blackStatusBarStyle];
}

#pragma mark - Public methods

- (void)setCountryListDataSource:(CLFCountryListDataSource *)countryListDataSource {
    if (_countryListDataSource != countryListDataSource) {
        _countryListDataSource = countryListDataSource;
        
        [self.tableView reloadData];
    }
}

#pragma mark - Actions

- (IBAction)cancelButtonTapped:(id)sender {
    if (_completionHandler) {
        _completionHandler(nil);
    }

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger result = [_countryListDataSource.sections[section] countries].count;
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLFCountryCell *cell = (CLFCountryCell *)[tableView dequeueReusableCellWithIdentifier:CLFCountryCellIdentifier
                                                                             forIndexPath:indexPath];
    
    CLFCountry *country = [_countryListDataSource.sections[indexPath.section] countries][indexPath.row];
    
    cell.name = country.name;
    cell.dialCode = country.dialCode;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger result = _countryListDataSource.sections.count;
    
    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *result = [_countryListDataSource.sections[section] sectionTitle];
    
    return result;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *result = nil;
    
    if (_countryListDataSource.sections.count > 1) {
        NSMutableArray *titles = [NSMutableArray new];
        for (CLFCountrySection *section in _countryListDataSource.sections) {
            [titles addObject:section.sectionTitle];
        }
        
        [titles insertObject:UITableViewIndexSearch
                     atIndex:0];
        
        result = [titles copy];
    }
    
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    NSInteger result = NSNotFound;
    
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [tableView setContentOffset:CGPointMake(0.0, -self.tableView.contentInset.top)
                           animated:YES];
    } else {
        result = index - 1;
    }
    
    return result;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLFCountry *selectedCountry = [_countryListDataSource.sections[indexPath.section] countries][indexPath.row];
    
    if (_completionHandler) {
        _completionHandler(selectedCountry);
    }

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    [_countryListDataSource filterCountriesByName:searchString];
    
    return YES;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [_countryListDataSource filterCountriesByName:searchController.searchBar.text];
    
    [self.tableView reloadData];
}

#pragma mark -

@end
