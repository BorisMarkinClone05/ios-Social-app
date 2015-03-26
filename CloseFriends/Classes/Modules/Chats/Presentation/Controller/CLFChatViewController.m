/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChatViewController.h"
#import "CLFContactAvatarView.h"

#import "CLFChatMessageTextView.h"
#import "CLFChatMessageInputView.h"
#import "CLFMacros.h"
#import "CLFChatMessageInputViewController.h"

#import "CLFChatInterface.h"
#import "CLFContactInterface.h"

#import "CLFContentManager.h"
#import "CLFChatMessage.h"


@interface CLFChatViewController ()

@property (nonatomic, weak) CLFContactAvatarView *companionAvatarView;

//chat message input view
@property (weak, nonatomic) IBOutlet CLFChatMessageInputView *messageInputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageInputBottomLayoutGuide;
@property (nonatomic, strong) CLFChatMessageInputViewController *messageInputController;

@property (strong, nonatomic) NSMutableArray *dataSource;

//Avatar images
@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;

@end


@implementation CLFChatViewController


#pragma mark -
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
    CLFContactAvatarView *avatarView = [[CLFContactAvatarView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:avatarView];
    
    self.companionAvatarView = avatarView;
}

- (void)setChat:(id<CLFChatInterface>)chat
{
    if (chat != _chat)
    {
        _chat = chat;
        self.title = chat.contact.fullName;
        self.detailTitle = chat.contact.statusAsString;
        
        [self.companionAvatarView configureWithContact:chat.contact];
    }
}


#pragma mark -
#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //partner avatar image
    self.myImage = nil;
    self.partnerImage = self.companionAvatarView.imageView.image;
    
    [self loadMessages];

    [self.view bringSubviewToFront:self.messageInputView];

    self.messageInputController = [[CLFChatMessageInputViewController alloc] initWithInputView:self.messageInputView];
    self.messageInputController.delegate = self;
    
    [self startToObserveKeyboard];
    
    if (panGesture)
    {
        [self.view removeGestureRecognizer:panGesture];
    }
    
    if (tapGesture)
    {
        [self.view removeGestureRecognizer:tapGesture];
    }
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForDismissKeyboard:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];

    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanForDismissKeyboard:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    self.textInitialHeight = 40.0f;
    self.textMaxHeight = 130.0f;
    self.textleftMargin = 5.0f;
    self.textTopMargin = 5.5f;
    self.textBottomMargin = 5.5f;

    [self adjustPosition];
}

- (void)loadMessages
{
    self.dataSource = [[[CLFContentManager sharedManager] generateConversation] mutableCopy];
}


#pragma mark -
#pragma mark - CLFMessaging data source delegater

- (NSMutableArray *)messages
{
    return self.dataSource;
}

- (NSTimeInterval)intervalForMessagesGrouping
{
    return 2 * 24 * 3600;
}

- (void)configureMessageCell:(CLFMessageCell *)cell forMessageAtIndex:(NSInteger)index
{
    CLFChatMessage *message = self.dataSource[index];
    
    if (!message.fromMe)
    {
        cell.contentInsets = UIEdgeInsetsMake(0, 3.0f, 0, 0);
        cell.textView.textColor = [UIColor blackColor];
    }
    else
    {
        cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 3.0f);
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.userImageView.layer.cornerRadius = self.userImageSize.width/2;
    
    // Fix user image position on top or bottom.
    cell.userImageView.autoresizingMask = message.fromMe ? UIViewAutoresizingFlexibleTopMargin : UIViewAutoresizingFlexibleBottomMargin;
    
    // Set user(me or partner) avatar images
    cell.userImage = message.fromMe ? self.myImage : self.partnerImage;
}

#pragma mark - Keyboard notifications

- (void)startToObserveKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotificationReceived:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotificationReceived:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)stopToObserveKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardNotificationReceived:(NSNotification *)notification
{
    NSString *notificationName = notification.name;

    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = keyboardRect;

    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardDuration = duration;

    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    keyboardCurve = curve;

    if ([notificationName isEqualToString:UIKeyboardWillShowNotification] ||
        [notificationName isEqualToString:UIKeyboardWillHideNotification])
    {
        [self handleKeyboardShowHideNotification:notification];
    }
}

- (void)handleKeyboardShowHideNotification:(NSNotification*) notification
{
    NSString *notificationName = notification.name;

    NSDictionary *info = notification.userInfo;
    
    if (info)
    {
        CGRect keyFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
        if (CGRectIsNull(keyFrame))
        {
            return;
        }
        
        CGRect convertedFrame = [self.view convertRect:keyFrame fromView:nil];
        
        UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        NSInteger animationCurveOption = (animationCurve << 16);
        
        double animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if (([notificationName isEqualToString:UIKeyboardWillShowNotification])&&(self.messageInputBottomLayoutGuide.constant != CGRectGetHeight(convertedFrame)))
        {
            self.messageInputBottomLayoutGuide.constant = CGRectGetHeight(convertedFrame);
            
            [self handleKeyboardWillShowNote:notification];
            
            [UIView animateWithDuration:animationDuration
                                  delay:0.0
                                options:animationCurveOption
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        }
        else if (([notificationName isEqualToString:UIKeyboardWillHideNotification])&&(self.messageInputBottomLayoutGuide.constant == CGRectGetHeight(convertedFrame)))
        {
            self.messageInputBottomLayoutGuide.constant = 0.0f;
            
            [self handleKeyboardWillHideNote:notification];
            
            [UIView animateWithDuration:animationDuration
                                  delay:0.0
                                options:animationCurveOption
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        }
    }
}


#pragma mark -
#pragma mark - Gestures

- (void)handleTapForDismissKeyboard:(UITapGestureRecognizer *)tap
{
    if ([self.messageInputController.messageTextView isFirstResponder])
    {
        [self.messageInputController.messageTextView resignFirstResponder];
    }
}

- (void)handlePanForDismissKeyboard:(UIPanGestureRecognizer *)pan
{
    if ([self.messageInputController.messageTextView isFirstResponder])
    {
        [self.messageInputController.messageTextView resignFirstResponder];
    }
}


#pragma mark - Public methods

- (void)adjustPosition
{
    CGRect frame = self.messageInputView.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height;
    self.messageInputView.frame = frame;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, self.messageInputView.frame.size.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - private Methods
- (void)adjustTextViewSize
{
    CGRect usedFrame = [self.messageInputController.messageTextView.layoutManager usedRectForTextContainer:self.messageInputController.messageTextView.textContainer];
    
    CGRect frame = self.messageInputController.messageTextView.frame;
    CGFloat delta = ceilf(usedFrame.size.height) - frame.size.height;
    
    CGFloat lineHeight = self.messageInputController.messageTextView.font.lineHeight;
    int numberOfActualLines = (int)ceilf(usedFrame.size.height / lineHeight);
    
    CGFloat actualHeight = numberOfActualLines * lineHeight;
    
    delta = actualHeight - self.messageInputController.messageTextView.frame.size.height; //self.textView.font.lineHeight - 5;
    
    CGRect frm = self.messageInputView.frame;
    frm.size.height += ceilf(delta);
    frm.origin.y -= ceilf(delta);
    
    if (frm.size.height < self.textMaxHeight)
    {
        if (frm.size.height < self.textInitialHeight)
        {
            frm.size.height = self.textInitialHeight;
            frm.origin.y = self.view.bounds.size.height - frm.size.height - keyboardFrame.size.height;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.messageInputView.frame = frm;
            
        } completion:^(BOOL finished) {
            [self scrollToCaretInTextView:self.messageInputController.messageTextView animated:NO];
        }];
    }
    else
    {
        [self scrollToCaretInTextView:self.messageInputController.messageTextView animated:NO];
    }
}

#pragma mark - Notifications handlers
- (void)handleKeyboardWillShowNote:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect windowRect = self.messageInputView.window.bounds;

    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        keyboardRect = CGRectMake(keyboardRect.origin.x, keyboardRect.origin.y, MAX(keyboardRect.size.width,keyboardRect.size.height), MIN(keyboardRect.size.width,keyboardRect.size.height));
        windowRect = CGRectMake(windowRect.origin.x, windowRect.origin.y, MAX(windowRect.size.width,windowRect.size.height), MIN(windowRect.size.width,windowRect.size.height));
    }
    
    keyboardFrame = keyboardRect;
    
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    keyboardCurve = curve;
    
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardDuration = duration;
    
    [self adjustTableViewWithCurve:YES scrollsToBottom:YES];
}

- (void)handleKeyboardWillHideNote:(NSNotification *)notification
{
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardCurve = curve;
    keyboardDuration = duration;

    keyboardFrame = CGRectZero;
    
    [self adjustTableViewWithCurve:YES scrollsToBottom:YES];
}

- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

- (void)adjustTableViewWithCurve:(BOOL)withCurve scrollsToBottom:(BOOL)scrollToBottom
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, keyboardFrame.size.height + self.messageInputController.messageTextView.frame.size.height, 0.0);
    
    NSInteger section = [(id<UITableViewDataSource>)self.tableView.delegate numberOfSectionsInTableView:self.tableView] - 1;
    
    if (section == -1)
    {
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
        return;
    }
    
    NSInteger row = [(id<UITableViewDataSource>)self.tableView.delegate tableView:self.tableView numberOfRowsInSection:section] - 1;
    
    if (row >= 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        [UIView beginAnimations:@"anim" context:NULL];
        [UIView setAnimationDuration:keyboardDuration];
        
        if (withCurve)
        {
            [UIView setAnimationCurve:keyboardCurve];
        }
        
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
        
        if (scrollToBottom)
        {
            if (row >= 0)
            {
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
        
        [UIView commitAnimations];
    }
    else
    {
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }
}


#pragma mark - 
#pragma mark - CLFChatMessageInputViewControllerDelegate

- (void) sendTextMessageFromInputView
{
    NSString *message = self.messageInputController.messageTextView.text;
    self.messageInputController.messageTextView.text = @"";
    [self adjustTextViewSize];
    
    [self.messageInputController.messageTextView setNeedsDisplay];
    [self.messageInputController.messageTextView setNeedsLayout];

    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        return;
    }
    
    CLFChatMessage *msg = [[CLFChatMessage alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    
    [self sendMessage:msg];
}

- (void)openCameraFromInputView
{
    NSLog(@"open camera");
}

- (void)openRecordFromInputView
{
    NSLog(@"opne record");
}

- (void)openMediaWithType:(NSInteger) mediaType
{
    switch (mediaType)
    {
        case CLFMediaTypePhoto:
            [self openAllPhotos];
            break;
        case CLFMediaTypeAlbum:
            [self openAlbums];
            break;
        case CLFMediaTypeLocation:
            [self openMap];
            break;
        case CLFMediaTypeVideo:
            [self openVideos];
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark -

-(void) openAllPhotos
{
    NSLog(@"open All Photos gallery");
    
//    if (!self.customAssetPickerController)
//    {
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//        self.customAssetPickerController = [sb instantiateViewControllerWithIdentifier:@"CLFAssetPickerController"];
//        self.customAssetPickerController.delegate = self;
//        self.customAssetPickerController.filterType = PHAssetMediaTypeImage;
//    }
//    
//    [self presentViewController:self.customAssetPickerController animated:YES completion:nil];
}

-(void) openAlbums
{
    NSLog(@"open Photo Albums");
}

-(void) openMap
{
    NSLog(@"open map");
}

-(void) openVideos
{
    NSLog(@"open All Videos gallery");
    
//    if (!self.customAssetPickerController)
//    {
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//        self.customAssetPickerController = [sb instantiateViewControllerWithIdentifier:@"CLFAssetPickerController"];
//        self.customAssetPickerController.delegate = self;
//        self.customAssetPickerController.filterType = PHAssetMediaTypeVideo;
//    }
//    
//    [self presentViewController:self.customAssetPickerController animated:YES completion:nil];
}

@end
