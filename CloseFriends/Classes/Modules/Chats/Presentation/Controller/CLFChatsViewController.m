/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChatsViewController.h"
#import "UIViewController+StatusBarAppearance.h"
#import "CLFChatsAdapter.h"
#import "CLFChatViewController.h"

#import "CLFAppearanceManager.h"

#import "CLFChatGroup.h"
#import "CLFChat.h"
#import "CLFContact.h"
#import "UIActionSheet+Blocks.h"

static NSString * const ShowChatSegueIdentifier = @"Show Chat";

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


@interface CLFChatsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *chatsTable;

@property (nonatomic, strong) CLFChatsAdapter *adapter;
@property (nonatomic, strong) NSArray *chatGroups;

@property (nonatomic, strong) UIBarButtonItem *editChatsBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *addNewChatBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;

@property (nonatomic, strong) id<CLFChatInterface> selectedChat;

@end

@implementation CLFChatsViewController


- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream
{
    return [[self appDelegate] xmppStream];
}

- (XMPPRoster *)xmppRoster
{
    return [[self appDelegate] xmppRoster];
}


#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [self commonInitialzation];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInitialzation];
    }
    
    return self;
}

- (void)commonInitialzation
{
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Chats"
                                                    image:[UIImage imageNamed:@"chatsTabIcon"]
                                            selectedImage:[UIImage imageNamed:@"chatsTabIconSelected"]];
    self.title = @"Chats";
    self.detailTitle = @"1 UNREAD";
    
    [self configureBarItems];
    
    CLFChatGroup *group1 = [[CLFChatGroup alloc] initWithChats:@[[[CLFChat alloc] initWithContact:[[CLFContact alloc] initWithFullName:@"Maya Smith"]],
                                                                 [[CLFChat alloc] initWithContact:[[CLFContact alloc] initWithFullName:@"Jackie Smith"]]]
                                                         title:@"TODAY"];
    CLFChatGroup *group2 = [[CLFChatGroup alloc] initWithChats:@[[[CLFChat alloc] initWithContact:[[CLFContact alloc] initWithFullName:@"Alvin Clark"]],
                                                                 [[CLFChat alloc] initWithContact:[[CLFContact alloc] initWithFullName:@"Gertrude Miller"]],
                                                                 [[CLFChat alloc] initWithContact:[[CLFContact alloc] initWithFullName:@"Beth Alvarez"]],
                                                                 [[CLFChat alloc] initWithContact:[[CLFContact alloc] initWithFullName:@"Ava Cooper"]]]
                                                         title:@"YESTERDAY"];
    self.chatGroups = @[group1, group2];
}

#pragma mark - Configure bar items

- (void)configureBarItems {
    self.editChatsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(editChatsBarButtonTapped:)];
    self.addNewChatBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"newChatIcon"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(addNewChatBarButtonTapped:)];
    self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(doneBarButtonTapped:)];
    
    self.navigationItem.leftBarButtonItems = @[self.editChatsBarButtonItem];
    self.navigationItem.rightBarButtonItems = @[[self fixedSpaceBarButtonItem], self.addNewChatBarButtonItem];
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
    
    self.chatsTable.tableFooterView = [UIView new];
    
    self.adapter = [[CLFChatsAdapter alloc] initWithTableView:self.chatsTable
                                                   chatGroups:self.chatGroups];
    
    __weak typeof(self)weakSelf = self;
    self.adapter.commitEditingStyleBlock = ^(UITableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            id<CLFChatInterface> chat = [weakSelf.chatGroups[indexPath.section] chats][indexPath.row];
            id<CLFContactInterface> contact = chat.contact;
            
            NSString *title = [NSString stringWithFormat:@"Delete chat history with %@?", [contact fullName]];
            [UIActionSheet showInView:weakSelf.view
                            withTitle:title
                    cancelButtonTitle:@"Cancel"
               destructiveButtonTitle:@"Delete"
                    otherButtonTitles:nil
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 
                             }];
        }
    };
    
    self.adapter.didSelectRowBlock = ^(UITableView *tableView, NSIndexPath *indexPath) {
        weakSelf.selectedChat = [weakSelf.chatGroups[indexPath.section] chats][indexPath.row];
        [weakSelf performSegueWithIdentifier:ShowChatSegueIdentifier
                                      sender:weakSelf];
    };
    
    
    onlineBuddies = [[NSMutableArray alloc ] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString* title;
    
    if ([[self appDelegate] connect])
    {
        title = [[[[self appDelegate] xmppStream] myJID] bare];
    } else
    {
        title = @"No JID";
    }
    
    NSLog(@"%@", title);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSInteger sections = [[[self fetchedResultsController] sections] count];

    NSLog(@"sections:%d", sections);
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil)
    {
        NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_roster];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                                  inManagedObjectContext:moc];
        
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
        
        NSArray *sortDescriptors = @[sd1, sd2];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];
        
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:moc
                                                                         sectionNameKeyPath:@"sectionNum"
                                                                                  cacheName:nil];
        [fetchedResultsController setDelegate:self];
        
        
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error])
        {
            DDLogError(@"Error performing fetch: %@", error);
        }
        
    }
    
    return fetchedResultsController;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.chatsTable setEditing:editing animated:animated];
    
    if (editing)
    {
        [self.navigationItem setLeftBarButtonItem:nil
                                         animated:animated];
        [self.navigationItem setRightBarButtonItems:@[self.doneBarButtonItem]
                                           animated:animated];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItems:@[self.editChatsBarButtonItem]
                                          animated:animated];
        [self.navigationItem setRightBarButtonItems:@[[self fixedSpaceBarButtonItem], self.addNewChatBarButtonItem]
                                           animated:animated];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self)
    {
        if ([segue.identifier isEqualToString:ShowChatSegueIdentifier])
        {
            CLFChatViewController *chatVC = (CLFChatViewController *)segue.destinationViewController;
            chatVC.chat = self.selectedChat;
            chatVC.hidesBottomBarWhenPushed = YES;
            
            self.selectedChat = nil;
        }
    }
}

#pragma mark - Actions

- (void)editChatsBarButtonTapped:(id)sender {
    [self setEditing:YES animated:YES];
}

- (void)addNewChatBarButtonTapped:(id)sender {
    
}

- (void)doneBarButtonTapped:(id)sender {
    [self setEditing:NO animated:YES];
}

#pragma mark -
#pragma mark Chat delegate

- (void)newBuddyOnline:(NSString *)buddyName
{
    if (![onlineBuddies containsObject:buddyName])
    {
        [onlineBuddies addObject:buddyName];
//        [self.tView reloadData];
        
    }
    
}

- (void)buddyWentOffline:(NSString *)buddyName
{
    [onlineBuddies removeObject:buddyName];
//    [self.tView reloadData];
    
}

- (void)didDisconnect
{
    [onlineBuddies removeAllObjects];
//    [self.tView reloadData];
    
}


@end
