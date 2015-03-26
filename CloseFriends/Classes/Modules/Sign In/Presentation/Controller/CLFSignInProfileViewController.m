/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFSignInProfileViewController.h"
#import "CLFAppearanceManager.h"
#import "UIViewController+StatusBarAppearance.h"
#import "CLFTextFieldCell.h"
#import "CLFSignInFacebookCell.h"

static NSString * const CLFTextFieldCellIdentifier = @"CLFTextFieldCell";
static NSString * const CLFSignInFacebookCellIdentifier = @"CLFSignInFacebookCell";

@interface CLFSignInProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CLFSignInProfileViewController

#pragma mark - UIViewController

- (void)awakeFromNib {
    [super awakeFromNib];

    [CLFAppearanceManager sharedInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:CLFTextFieldCellIdentifier bundle:nil]
         forCellReuseIdentifier:CLFTextFieldCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:CLFSignInFacebookCellIdentifier bundle:nil]
         forCellReuseIdentifier:CLFSignInFacebookCellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [cell becomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self defaultPreferredStatusBarStyle];
}

#pragma mark - Actions
- (IBAction)iconButtonTapped:(id)sender {
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:@"Cancel"
                  destructiveButtonTitle:nil
                       otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)doneButtonTapped:(id)sender {

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [self nameCell];
    } else if (indexPath.row == 1) {
        cell = [self facebookCell];
    }
    return cell;
}

- (CLFTextFieldCell *)nameCell {
    CLFTextFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CLFTextFieldCellIdentifier];
    cell.title = @"NAME";
    return cell;
}

- (CLFSignInFacebookCell *)facebookCell {
    return [self.tableView dequeueReusableCellWithIdentifier:CLFSignInFacebookCellIdentifier];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 58.0f;
    }
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
    } else if (indexPath.row == 1) {
        NSLog(@"Get from facebook tapped");
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

}

@end