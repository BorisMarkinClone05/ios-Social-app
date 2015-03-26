/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFAddContactViewController.h"
#import "CLFAddContactFromCell.h"
#import "CLFTextFieldCell.h"
#import "UIViewController+StatusBarAppearance.h"

@import AddressBookUI;

static NSString * const AddContactFromCellIdentifier = @"CLFAddContactFromCell";
static NSString * const TextFieldCellIdentifier = @"CLFTextFieldCell";

@interface CLFAddContactViewController ()
<
    ABPeoplePickerNavigationControllerDelegate,
    UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBarButtonItem;

@property (nonatomic, strong) CLFTextFieldCell *emailOrPhoneCell;

@end

@implementation CLFAddContactViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFAddContactFromCell class])
                                               bundle:nil]
         forCellReuseIdentifier:AddContactFromCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFTextFieldCell class])
                                               bundle:nil]
         forCellReuseIdentifier:TextFieldCellIdentifier];
    
    self.tableView.rowHeight = 44.0;
    
    self.sendBarButtonItem.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self defaultPreferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    return [self defaultPrefersStatusBarHidden];
}

#pragma mark - Actions

- (IBAction)cancelButtonTapped:(id)sender {
    if (self.completionHandler) {
        self.completionHandler(nil);
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (IBAction)sendButtonTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        numberOfRows = 1;
    }
    else if (section == 1) {
        numberOfRows = 1;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    
    if (indexPath.section == 0) {
        if (self.emailOrPhoneCell == nil) {
            self.emailOrPhoneCell = (CLFTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:TextFieldCellIdentifier
                                                                                         forIndexPath:indexPath];
            self.emailOrPhoneCell.title = @"EMAIL OR PHONE";
            self.emailOrPhoneCell.detailTextField.delegate = self;
        }
        
        result = self.emailOrPhoneCell;
    }
    else if (indexPath.section == 1) {
        CLFAddContactFromCell *cell = (CLFAddContactFromCell *)[tableView dequeueReusableCellWithIdentifier:AddContactFromCellIdentifier
                                                                                               forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.title = @"ADDRESS BOOK";
        }
        
        result = cell;
    }
    
    return result;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ABPeoplePickerNavigationController *peoplePicker = [ABPeoplePickerNavigationController new];
            peoplePicker.peoplePickerDelegate = self;
            
            [self presentViewController:peoplePicker
                               animated:YES
                             completion:nil];
        }
    }
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person {
    if (person) {
        self.emailOrPhoneCell.detail = [self phoneOrEmailFromPerson:person];
        self.sendBarButtonItem.enabled = self.emailOrPhoneCell.detail.length > 0;
    }
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    if (person) {
        self.emailOrPhoneCell.detail = [self phoneOrEmailFromPerson:person];
        self.sendBarButtonItem.enabled = self.emailOrPhoneCell.detail.length > 0;
    }
    
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                                                       replacementString:(NSString *)string {
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range
                                                                     withString:string];
    
    self.sendBarButtonItem.enabled = resultString.length > 0;
    
    return YES;
}

#pragma mark - Helper methods

- (NSString *)phoneOrEmailFromPerson:(ABRecordRef)person {
    NSString *phoneOrEmail = nil;
    
    if (person) {
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if (phones) {
            NSMutableDictionary *phoneByPhoneLabel = [NSMutableDictionary new];
            
            for (CFIndex i = 0; i < ABMultiValueGetCount(phones); ++i) {
                NSString *phoneLabel = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
                NSString *phoneNumber = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                
                phoneByPhoneLabel[phoneLabel] = phoneNumber;
            }
            
            CFRelease(phones);
            
            if (phoneByPhoneLabel[(NSString *)kABPersonPhoneMobileLabel]) {
                phoneOrEmail = phoneByPhoneLabel[(NSString *)kABPersonPhoneMobileLabel];
            }
            else if (phoneByPhoneLabel[(NSString *)kABPersonPhoneIPhoneLabel]) {
                phoneOrEmail = phoneByPhoneLabel[(NSString *)kABPersonPhoneIPhoneLabel];
            }
            else if (phoneByPhoneLabel[(NSString *)kABPersonPhoneMainLabel]) {
                phoneOrEmail = phoneByPhoneLabel[(NSString *)kABPersonPhoneMainLabel];
            }
            else if (phoneByPhoneLabel[(NSString *)kABPersonPhoneHomeFAXLabel]) {
                phoneOrEmail = phoneByPhoneLabel[(NSString *)kABPersonPhoneHomeFAXLabel];
            }
            else if (phoneByPhoneLabel[(NSString *)kABPersonPhoneWorkFAXLabel]) {
                phoneOrEmail = phoneByPhoneLabel[(NSString *)kABPersonPhoneWorkFAXLabel];
            }
            else if (phoneByPhoneLabel[(NSString *)kABPersonPhoneOtherFAXLabel]) {
                phoneOrEmail = phoneByPhoneLabel[(NSString *)kABPersonPhoneOtherFAXLabel];
            }
        }
        
        if (!phoneOrEmail) {
            ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
            if (emails) {
                phoneOrEmail = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, 0));
                
                CFRelease(emails);
            }
        }
    }
    
    return phoneOrEmail;
}

#pragma mark -

@end
