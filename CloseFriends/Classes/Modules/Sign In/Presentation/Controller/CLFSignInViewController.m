/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFSignInViewController.h"
#import "CLFCountryListDataSource.h"
#import "CLFStoryboardProvider.h"
#import "CLFCountryPickerViewController.h"
#import "CLFPhoneNumber.h"
#import "CLFCountry.h"
#import "CLFSignInCountryCell.h"
#import "CLFSignInPhoneCell.h"
#import "UIViewController+StatusBarAppearance.h"
#import "CLFCodeViewController.h"

static const CGFloat kTableViewCornerRadius = 10.0f;
static const CGFloat kTableViewBorderWidth = 0.0f;
static const CGFloat kIndentFromKeyboard = 20.0f;
static const CGFloat kSignInCornerRadius = 20.0f;

static NSString * const CLFCodeSegue = @"CLFCodeSegue";

static NSString * const CLFSignInCountryCellIdentifier = @"CLFSignInCountryCell";
static NSString * const CLFSignInPhoneCellIdentifier = @"CLFSignInPhoneCell";

@interface CLFSignInViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) CLFCountryListDataSource *countryListDataSource;

@property (nonatomic, strong) CLFPhoneNumber *phoneNumber;
@property (nonatomic, strong) CLFCountry *country;
@property (nonatomic, strong) CLFSignInPhoneCell *phoneCell;

@property (nonatomic) BOOL isShowingKeyboard;

@end

@implementation CLFSignInViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.layer.cornerRadius = kTableViewCornerRadius;
    _tableView.layer.borderWidth = kTableViewBorderWidth;

    [self.tableView registerNib:[UINib nibWithNibName:CLFSignInCountryCellIdentifier
                                               bundle:nil]
         forCellReuseIdentifier:CLFSignInCountryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:CLFSignInPhoneCellIdentifier
                                               bundle:nil]
         forCellReuseIdentifier:CLFSignInPhoneCellIdentifier];

    _signInButton.layer.cornerRadius = kSignInCornerRadius;

    [self.tapRecognizer addTarget:self action:@selector(backgroundTapped:)];
    self.tapRecognizer.delegate = self;

    _countryListDataSource = [[CLFCountryListDataSource alloc] init];
    _country = [_countryListDataSource countryByDialCode:@"+1"];
    _phoneNumber = [[CLFPhoneNumber alloc] initWithCountry:_country];
}

//TODO: Check on the device
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    [self.scrollView layoutIfNeeded];
//    [self registerForKeyboardNotifications];
//    if (_isShowingKeyboard)  {
//        [self showKeyboard];
//    }
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerForKeyboardNotifications];
    if (_isShowingKeyboard)  {
        [self showKeyboard];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeRegistrationForKeyboardNotifications];
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self defaultPreferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    return [self defaultPrefersStatusBarHidden];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:CLFCodeSegue]) {
        CLFCodeViewController *codeVC = (CLFCodeViewController *)segue.destinationViewController;
        codeVC.phoneNumber = _phoneNumber;
    }
}

- (void)openCountryViewController {
    UINavigationController *navigationController = [[[CLFStoryboardProvider sharedInstance] countryListStoryboard] instantiateInitialViewController];
    CLFCountryPickerViewController *countryPickerVC = (CLFCountryPickerViewController *) navigationController.topViewController;
    countryPickerVC.countryListDataSource = _countryListDataSource;
    __weak typeof(self) weakSelf = self;
    countryPickerVC.completionHandler = ^(CLFCountry *selectedCountry) {
        if (selectedCountry) {
            [weakSelf countryChanged:selectedCountry];
            weakSelf.isShowingKeyboard = YES;
        }
    };

    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Actions
- (IBAction)signInButtonTapped:(id)sender {
    [self performSegueWithIdentifier:CLFCodeSegue sender:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [self countryCell];
    } else {
        cell = [self phoneCell];
    }
    return cell;
}

- (CLFSignInCountryCell *)countryCell {
    CLFSignInCountryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CLFSignInCountryCellIdentifier];
    cell.title = @"COUNTRY";
    if (_country) {
        cell.countryName = _country.name;
    } else {
        cell.countryName = @"Invalid Country Code";
    }
    return cell;
}

- (CLFSignInPhoneCell *)phoneCell {
    CLFSignInPhoneCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CLFSignInPhoneCellIdentifier];
    self.phoneCell = cell;
    __weak typeof(self) weakSelf = self;
    [cell configureCellWithPhoneNumber:_phoneNumber andCodeСhangesHandler:^(NSString *code) {
        [weakSelf codeChanged:code];
    }];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        [self openCountryViewController];
    }
}

#pragma mark - Keyboard showing
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

- (void)removeRegistrationForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
        NSDictionary *info = [aNotification userInfo];
        CGSize kbSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        _scrollView.contentInset = contentInsets;
        _scrollView.scrollIndicatorInsets = contentInsets;

        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, _signInButton.frame.origin)) {
            CGRect frame = _signInButton.frame;
            frame.size.height = frame.size.height + kIndentFromKeyboard;
            [self.scrollView scrollRectToVisible:frame animated:YES];
        }

        self.isShowingKeyboard = YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (!_isShowingKeyboard) {
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        [UIView animateWithDuration:0.3f animations:^{
            _scrollView.contentInset = contentInsets;
            _scrollView.scrollIndicatorInsets = contentInsets;
        }];
    }
}

- (void)showKeyboard {
    CLFSignInPhoneCell *phoneCell = (CLFSignInPhoneCell *) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    [phoneCell becomeFirstResponder];
}

#pragma mark - Gesture recognizer
- (void)backgroundTapped:(id)sender {
    self.isShowingKeyboard = NO;
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isDescendantOfView:self.tableView];
}

#pragma mark - Private methods
- (void)countryChanged:(CLFCountry *)selectedCountry {
    self.country = selectedCountry;
    [self.phoneNumber updateCodeFromCountry:self.country];
    [self.tableView reloadData];
}

- (void)codeChanged:(NSString *)code {
    self.country = [self.countryListDataSource countryByDialCode:code];
    if (_country) {
        [_phoneNumber updateCodeFromCountry:_country];
    } else {
        [_phoneNumber updateCodeFromCountry:[CLFCountry countryWithName:nil code:nil dialCode:code]];
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

@end