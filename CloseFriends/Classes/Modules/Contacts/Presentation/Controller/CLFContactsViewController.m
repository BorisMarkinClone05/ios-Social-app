/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFContactsViewController.h"

//Presentation
#import "UIViewController+StatusBarAppearance.h"

#import "CLFAppearanceManager.h"
#import "CLFTheme.h"

#import "CLFContactsAdapter.h"
#import "CLFContactsSectionHeaderView.h"

#import "CLFAddContactViewController.h"

#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"

//Model
#import "CLFContactGroup.h"
#import "CLFContact.h"

static NSString * const PresentAddContactModallySegueIdentifier = @"Present Add Contact Modally";

static NSString * const CancelButtonTitle = @"Cancel";
static NSString * const DeleteButtonTitle = @"Delete";
static NSString * const RenameButtonTitle = @"Rename";

@interface CLFContactsViewController ()
<
    CLFContactsSectionHeaderViewDelegate
>

@property (nonatomic, strong) UIBarButtonItem *editContactsBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *addContactBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *createGroupBarButtonItem;

@property (weak, nonatomic) IBOutlet UITableView *contactsTable;

@property (nonatomic, strong) NSArray *contactGroups;

@property (nonatomic, strong) CLFContactsAdapter *adapter;

@property (nonatomic, strong) id<CLFContactGroupInterface> editingContactGroup;

@end

@implementation CLFContactsViewController

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        [self commonInitialzation];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialzation];
    }
    
    return self;
}

- (void)commonInitialzation {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Contacts"
                                                    image:[UIImage imageNamed:@"contactsTabIcon"]
                                            selectedImage:[UIImage imageNamed:@"contactsTabIconSelected"]];
    self.title = @"Contacts";
    self.detailTitle = @"4 ONLINE";
    
    [self configureNavitationBarItems];
    
    CLFContactGroup *group1 = [[CLFContactGroup alloc] initWithName:@"FAMILY"
                                                           contacts:@[
                                                                      [[CLFContact alloc] initWithFullName:@"Maya Smith"],
                                                                      [[CLFContact alloc] initWithFullName:@"Jackie Smith"]
                                                                      ]];
    CLFContactGroup *group2 = [[CLFContactGroup alloc] initWithName:@"FRIENDS"
                                                           contacts:@[
                                                                      [[CLFContact alloc] initWithFullName:@"Alvin Clark"],
                                                                      [[CLFContact alloc] initWithFullName:@"Gertrude Miller"],
                                                                      [[CLFContact alloc] initWithFullName:@"Beth Alvarez"],
                                                                      [[CLFContact alloc] initWithFullName:@"Ava Cooper"]
                                                                      ]];
    self.contactGroups = @[group1, group2];
}

#pragma mark - Configure bar items

- (void)configureNavitationBarItems {
    self.editContactsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(navigationBarButtonItemTapped:)];
    self.addContactBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addContact"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(navigationBarButtonItemTapped:)];
    self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(navigationBarButtonItemTapped:)];
    self.createGroupBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New Group"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(navigationBarButtonItemTapped:)];
    
    
    
    self.navigationItem.leftBarButtonItems = @[self.editContactsBarButtonItem];
    self.navigationItem.rightBarButtonItems = @[[self fixedSpaceBarButtonItem], self.addContactBarButtonItem];
}

- (UIBarButtonItem *)fixedSpaceBarButtonItem {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:nil
                                                                                action:nil];
    fixedSpace.width = -12.0;
    
    return fixedSpace;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[[CLFAppearanceManager sharedInstance] currentTheme] generalBackgroundColor];
    
    self.adapter = [[CLFContactsAdapter alloc] initWithTableView:self.contactsTable
                                                   contactGroups:self.contactGroups];
    self.adapter.sectionHeaderDelegate = self;
    
    __weak typeof(self)weakSelf = self;
    self.adapter.didSelectRowBlock = ^(UITableView *tableView, NSIndexPath *indexPath) {
        NSArray *groupContacts = [weakSelf.contactGroups[indexPath.section] contacts];
        
        if (indexPath.row == [groupContacts count]) {
            [weakSelf performSegueWithIdentifier:PresentAddContactModallySegueIdentifier
                                          sender:weakSelf];
        }
    };
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self defaultPreferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    return [self defaultPrefersStatusBarHidden];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        self.title = @"EDIT CONTACTS";
        self.tabBarItem.title = @"Contacts";
        self.detailTitle = nil;
    }
    else {
        self.title = @"Contacts";
        self.tabBarItem.title = @"Contacts";
        self.detailTitle = @"4 ONLINE";
    }
    
    [self.contactsTable setEditing:editing
                          animated:animated];
    
    if (editing) {
        [self.navigationItem setLeftBarButtonItems:@[self.createGroupBarButtonItem]
                                          animated:animated];
        [self.navigationItem setRightBarButtonItems:@[self.doneBarButtonItem]
                                           animated:animated];
        
        NSMutableArray *rowsToInsert = [NSMutableArray new];
        for (int i = 0; i < self.contactGroups.count; ++i) {
            id<CLFContactGroupInterface> group = self.contactGroups[i];
            
            [rowsToInsert addObject:[NSIndexPath indexPathForRow:[[group contacts] count]
                                                       inSection:i]];
        }
        
        [self.contactsTable beginUpdates];
        [self.contactsTable insertRowsAtIndexPaths:rowsToInsert
                                  withRowAnimation:animated ? UITableViewRowAnimationFade : UITableViewRowAnimationNone];
        [self.contactsTable endUpdates];
    }
    else {
        [self.navigationItem setLeftBarButtonItems:@[self.editContactsBarButtonItem]
                                          animated:animated];
        [self.navigationItem setRightBarButtonItems:@[[self fixedSpaceBarButtonItem], self.addContactBarButtonItem]
                                           animated:animated];
        
        NSMutableArray *rowsToDelete = [NSMutableArray new];
        for (int i = 0; i < self.contactGroups.count; ++i) {
            id<CLFContactGroupInterface> group = self.contactGroups[i];
            
            [rowsToDelete addObject:[NSIndexPath indexPathForRow:[[group contacts] count]
                                                       inSection:i]];
        }
        
        [self.contactsTable beginUpdates];
        [self.contactsTable deleteRowsAtIndexPaths:rowsToDelete
                                  withRowAnimation:animated ? UITableViewRowAnimationFade : UITableViewRowAnimationNone];
        [self.contactsTable endUpdates];
    }
}

#pragma mark - CLFContactsSectionHeaderViewDelegate

- (void)contactsSectionHeaderEditGroupButtonTapped:(CLFContactsSectionHeaderView *)sectionHeader {
    if (sectionHeader) {
        self.editingContactGroup = sectionHeader.contactGroup;
        
        UIActionSheet *editGroupActionSheet = [UIActionSheet new];
        [editGroupActionSheet addButtonWithTitle:RenameButtonTitle];
        editGroupActionSheet.destructiveButtonIndex = [editGroupActionSheet addButtonWithTitle:DeleteButtonTitle];
        editGroupActionSheet.cancelButtonIndex = [editGroupActionSheet addButtonWithTitle:CancelButtonTitle];
        editGroupActionSheet.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            NSString *tappedButton = [actionSheet buttonTitleAtIndex:buttonIndex];
            if ([tappedButton isEqualToString:DeleteButtonTitle]) {
                [self showDeleteGroupAlertForGroup:self.editingContactGroup];
            }
            else if ([tappedButton isEqualToString:RenameButtonTitle]) {
                [self showRenameGroupAlertForGroup:self.editingContactGroup];
            }
        };
        
        [editGroupActionSheet showInView:self.view];
    }
}

#pragma mark - Actions

- (void)navigationBarButtonItemTapped:(id)sender {
    if (sender == self.editContactsBarButtonItem) {
        [self setEditing:YES animated:YES];
    }
    else if (sender == self.doneBarButtonItem) {
        [self setEditing:NO animated:YES];
    }
    else if (sender == self.createGroupBarButtonItem) {
        [self showCreateGroupAlert];
    }
    else if (sender == self.addContactBarButtonItem) {
        [self performSegueWithIdentifier:PresentAddContactModallySegueIdentifier
                                  sender:self];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender == self) {
        if ([segue.identifier isEqual:PresentAddContactModallySegueIdentifier]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            CLFAddContactViewController *addContactController = (CLFAddContactViewController *)navController.viewControllers[0];
            addContactController.completionHandler = ^(NSString *emailOrPhone) {
                
            };
        }
    }
}

#pragma mark - Helper methods

- (void)showCreateGroupAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create New Group"
                                                    message:@"Enter a name for the group."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"Name";
    
    alert.tapBlock = ^(UIAlertView *alert, NSInteger buttonIndex) {
        
    };
    
    alert.shouldEnableFirstOtherButtonBlock = ^ BOOL (UIAlertView *alert) {
        return [alert textFieldAtIndex:0].text.length > 0;
    };
    
    [alert show];
}

- (void)showDeleteGroupAlertForGroup:(id<CLFContactGroupInterface>)group {
    if (group) {
        NSString *message = [NSString stringWithFormat:@"Are you sure that you want to delete \"%@\" group?", group.name];
        
        [UIAlertView showWithTitle:@"Delete Group"
                           message:message
                 cancelButtonTitle:CancelButtonTitle
                 otherButtonTitles:@[DeleteButtonTitle]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:DeleteButtonTitle]) {
                                  //Handle delete
                              }
                          }];
    }
}

- (void)showRenameGroupAlertForGroup:(id<CLFContactGroupInterface>)group {
    if (group) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rename Group"
                                                        message:@"Enter a new name for the group."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Save", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.placeholder = @"Name";
        textField.text = group.name;
        
        alert.tapBlock = ^(UIAlertView *alert, NSInteger buttonIndex) {
            
        };
        
        alert.shouldEnableFirstOtherButtonBlock = ^ BOOL (UIAlertView *alert) {
            return [alert textFieldAtIndex:0].text.length > 0;
        };
        
        [alert show];
    }
}

#pragma mark -

@end
