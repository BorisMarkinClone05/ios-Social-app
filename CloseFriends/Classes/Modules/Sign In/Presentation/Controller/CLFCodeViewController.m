/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFCodeViewController.h"
#import "UIViewController+StatusBarAppearance.h"
#import "CLFPhoneNumber.h"
#import "CLFSignInButton.h"

static NSString * const CLFProfileSegue = @"CLFProfileSegue";

@interface CLFCodeViewController ()

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet CLFSignInButton *submitButton;

@end

@implementation CLFCodeViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [_phoneNumber formattedNumberWithDialCode];

    _codeView.layer.cornerRadius = 10.0f;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    [self registerForKeyboardNotifications];
    [_codeTextField becomeFirstResponder];
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

#pragma mark - Actions
- (IBAction)submitButtonTapped:(id)sender {
    [self performSegueWithIdentifier:CLFProfileSegue sender:self];
}

#pragma mark - Keyboard showing
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

- (void)removeRegistrationForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat residualHeight = self.view.frame.size.height - _submitButton.superview.frame.size.height;
    CGRect bkgndRect = _submitButton.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [_submitButton.superview setFrame:bkgndRect];
    CGFloat contentOffset = kbSize.height - residualHeight;
    if (contentOffset > 0) {
        [_scrollView setContentOffset:CGPointMake(0.0, contentOffset) animated:NO];
    }
}
@end