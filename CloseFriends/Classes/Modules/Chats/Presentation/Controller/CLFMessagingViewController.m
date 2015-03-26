/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFMessagingViewController.h"
#import "CLFMessage.h"
#import "CLFMessageCell.h"
#import "NSString+Calculation.h"
#import "CLFImageBrowserView.h"
#import "UIViewController+StatusBarAppearance.h"

#import <MediaPlayer/MediaPlayer.h>


@interface CLFMessagingViewController () <UITableViewDelegate, CLFMessageCellDelegate>

@property (nonatomic, weak) UILabel *titleLabel;
@property (strong, nonatomic) UIImage *balloonSendImage;
@property (strong, nonatomic) UIImage *balloonReceiveImage;
@property (strong, nonatomic) UIView *tableViewHeaderView;
@property (strong, nonatomic) NSMutableArray *conversation;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerController;
@property (strong, nonatomic) CLFImageBrowserView *imageBrowser;

@end


@implementation CLFMessagingViewController
{
    dispatch_once_t onceToken;
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
    return [[self appDelegate] xmppStream];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self)
    {
        [self initializeTitleLabel];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initializeTitleLabel];
    }
    
    return self;
}

- (void)setup
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];

    self.tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10)];
    self.tableViewHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.tableView];
}


#pragma mark -
#pragma mark - View lifecicle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
    
    self.balloonSendImage    = [self balloonImageForSending];
    self.balloonReceiveImage = [self balloonImageForReceiving];
    
    turnSockets = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc ] init];
    
    XMPPJID *jid = [XMPPJID jidWithString:@"cesare@YOURSERVER"];
    
    TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[self xmppStream] toJID:jid];
    
    [turnSockets addObject:turnSocket];
    
    [turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)initializeTitleLabel
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    
    self.navigationItem.titleView = titleLabel;
    self.titleLabel = titleLabel;
}


#pragma mark -
#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self defaultPreferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    return [self defaultPrefersStatusBarHidden];
}


#pragma mark -
#pragma mark - Public

- (void)setDetailTitle:(NSString *)detailTitle
{
    if (detailTitle != _detailTitle)
    {
        _detailTitle = [detailTitle copy];
        
        [self setTitleLabelTextWithTitle:self.title detailtTitle:self.detailTitle];
    }
}

- (void)setTitle:(NSString *)title
{
    if (title != [super title])
    {
        [super setTitle:title];
        
        [self setTitleLabelTextWithTitle:title detailtTitle:self.detailTitle];
    }
}


#pragma mark -
#pragma mark - Private

- (void)setTitleLabelTextWithTitle:(NSString *)title detailtTitle:(NSString *)detailTitle
{
    NSMutableAttributedString *attributedCombinedTitle = [NSMutableAttributedString new];
    
    if (title.length > 0)
    {
        UIFont *titleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:15.0];
        UIColor *titleColor = [UIColor whiteColor];
        
        NSAttributedString * attributedTitle = [[NSAttributedString alloc] initWithString:title
                                                                               attributes:@{
                                                                                            NSFontAttributeName : titleFont,
                                                                                            NSForegroundColorAttributeName : titleColor
                                                                                            }];
        [attributedCombinedTitle appendAttributedString:attributedTitle];
    }
    
    if (title.length > 0 && detailTitle.length > 0)
    {
        [attributedCombinedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    
    if (detailTitle.length > 0)
    {
        UIFont *detailFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:9.0];
        UIColor *detailColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        
        NSAttributedString *attributedDetailTitle = [[NSAttributedString alloc] initWithString:detailTitle
                                                                                    attributes:@{
                                                                                                 NSFontAttributeName : detailFont,
                                                                                                 NSForegroundColorAttributeName : detailColor
                                                                                                 }];
        [attributedCombinedTitle appendAttributedString:attributedDetailTitle];
    }
    
    self.titleLabel.attributedText = attributedCombinedTitle;
    [self.titleLabel sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.conversation = [self grouppedMessages];
    
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    dispatch_once(&onceToken, ^{
        
        if ([self.conversation count])
        {
            NSInteger section = self.conversation.count - 1;
            NSInteger row = [self.conversation[section] count] - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            if ( indexPath.row !=-1)
            {
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    });
}

// This code will work only if this vc hasn't navigation controller
- (BOOL)shouldAutorotate
{
    return YES;
}


#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.conversation.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 0)
    {
        return 0;
    }
    
    // Return the number of rows in the section.
    return [self.conversation[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    id<CLFMessage> message = self.conversation[indexPath.section][indexPath.row];
    int index = (int)[[self messages] indexOfObject:message];
    height = [self heightForMessageForIndex:index];

    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self intervalForMessagesGrouping])
        return 40;
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (![self intervalForMessagesGrouping])
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor clearColor];
    
    id<CLFMessage> firstMessageInGroup = [self.conversation[section] firstObject];
    NSDate *date = [firstMessageInGroup date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM, eee, HH:mm"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [formatter stringFromDate:date];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    [label sizeToFit];
    label.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"sendCell";

    CLFMessageCell *cell;

    id<CLFMessage> message = self.conversation[indexPath.section][indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[CLFMessageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier
                                    messageMaxWidth:[self messageMaxWidth]];
    }
    
    [cell setMediaImageViewSize:[self mediaThumbnailSize]];
    [cell setUserImageViewSize:[self userImageSize]];
    cell.tableView = self.tableView;
    cell.balloonMinHeight = [self balloonMinHeight];
    cell.balloonMinWidth  = [self balloonMinWidth];
    cell.delegate = self;
    cell.messageFont = [self messageFont];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.balloonImage = message.fromMe ? self.balloonSendImage : self.balloonReceiveImage;
    cell.textView.textColor = message.fromMe ? [UIColor whiteColor] : [UIColor blackColor];
    cell.message = message;    
    
    // For user customization
    int index = (int)[[self messages] indexOfObject:message];
    
    [self configureMessageCell:cell forMessageAtIndex:index];
    
    [cell adjustCell];
    
    return cell;
}


#pragma mark -
#pragma mark - CLFMessaging datasource

- (NSMutableArray *)messages
{
    return nil;
}

- (CGFloat)heightForMessageForIndex:(NSInteger)index
{
    CGFloat height;
    
    id<CLFMessage> message = [self messages][index];
    
    if (message.type == CLFMessageTypeText)
    {
        CGSize size = [message.text usedSizeForMaxWidth:[self messageMaxWidth] withFont:[self messageFont]];
        
        if (message.attributes)
        {
            size = [message.text usedSizeForMaxWidth:[self messageMaxWidth] withAttributes:message.attributes];
        }
        
        if (self.balloonMinWidth)
        {
            CGFloat messageMinWidth = self.balloonMinWidth - [CLFMessageCell messageLeftMargin] - [CLFMessageCell messageRightMargin];
            
            if (size.width <  messageMinWidth)
            {
                size.width = messageMinWidth;

                CGSize newSize = [message.text usedSizeForMaxWidth:messageMinWidth withFont:[self messageFont]];
                
                if (message.attributes)
                {
                    newSize = [message.text usedSizeForMaxWidth:messageMinWidth withAttributes:message.attributes];
                }
                
                size.height = newSize.height;
            }
        }
        
        CGFloat messageMinHeight = self.balloonMinHeight - ([CLFMessageCell messageTopMargin] + [CLFMessageCell messageBottomMargin]);
        
        if ([self balloonMinHeight] && size.height < messageMinHeight)
        {
            size.height = messageMinHeight;
        }
        
        size.height += [CLFMessageCell messageTopMargin] + [CLFMessageCell messageBottomMargin];
        
        if (!CGSizeEqualToSize([self userImageSize], CGSizeZero))
        {
            if (size.height < [self userImageSize].height)
            {
                size.height = [self userImageSize].height;
            }
        }
        
        height = size.height + kBubbleTopMargin + kBubbleBottomMargin;
    }
    else
    {
        CGSize size = [self mediaThumbnailSize];
        
        if (size.height < [self userImageSize].height)
        {
            size.height = [self userImageSize].height;
        }
        
        height = size.height + kBubbleTopMargin + kBubbleBottomMargin;
    }
    
    return height;
}

- (NSTimeInterval)intervalForMessagesGrouping
{
    return 0;
}

- (UIImage *)balloonImageForReceiving
{
    UIImage *bubble = [UIImage imageNamed:@"bubbleReceive"];
    UIColor *color = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0];
    UIColor *borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0];
    bubble = [self tintImage:bubble withColor:color border:borderColor];

    return [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(25, 20, 10, 10)];
}

- (UIImage *)balloonImageForSending
{
    UIImage *bubble = [UIImage imageNamed:@"bubble"];
    UIColor *color = [UIColor colorWithRed:0.0/255.0 green:173.0/255.0 blue:236.0/255.0 alpha:1.0];
    UIColor *borderColor = [UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:204.0/255.0 alpha:1.0];
    bubble = [self tintImage:bubble withColor:color border:borderColor];
    
    return [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 25, 20)];
}

- (void)configureMessageCell:(CLFMessageCell *)cell forMessageAtIndex:(NSInteger)index
{

}

- (CGFloat)messageMaxWidth
{
    CGFloat width = self.view.bounds.size.width * 0.8f - self.userImageSize.width;
    return width;
}

- (CGFloat)balloonMinHeight
{
    return 0;
}

- (CGFloat)balloonMinWidth
{
    return 0;
}

- (UIFont *)messageFont
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:14];
}

- (CGSize)mediaThumbnailSize
{
    return CGSizeMake(90, 100);
}

- (CGSize)userImageSize
{
    return CGSizeMake(40, 40);
}

#pragma mark - Public methods

#pragma mark -
#pragma mark - Send Message

- (void)sendMessage:(id<CLFMessage>) message
{
    message.fromMe = YES;
    NSMutableArray *messages = [self messages];
    [messages addObject:message];

    [self refreshMessages];
    
    
    
    
//    NSString *messageStr = message.text;
//    
//    if([messageStr length] > 0) {
//        
//        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//        [body setStringValue:messageStr];
//        
//        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
//        [message addAttributeWithName:@"type" stringValue:@"chat"];
//        [message addAttributeWithName:@"to" stringValue:chatWithUser];
//        [message addChild:body];
//        
//        [self.xmppStream sendElement:message];
//        
//        self.messageField.text = @"";
//        
//        
//        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
//        [m setObject:[messageStr substituteEmoticons] forKey:@"msg"];
//        [m setObject:@"you" forKey:@"sender"];
//        [m setObject:[NSString getCurrentTime] forKey:@"time"];
//        
//        [messages addObject:m];
//        [self.tView reloadData];
//        [m release];
//        
//    }

}


#pragma mark -
#pragma mark - Receive Message

- (void)receiveMessage:(id<CLFMessage>) message
{
    message.fromMe = NO;

    NSMutableArray *messages = [self messages];
    [messages addObject:message];

    [self refreshMessages];
}


#pragma mark -
#pragma mark - RefreshMessages

- (void)refreshMessages
{
    self.conversation = [self grouppedMessages];
    [self.tableView reloadData];
    
    NSInteger section = [self numberOfSectionsInTableView:self.tableView] - 1;
    NSInteger row     = [self tableView:self.tableView numberOfRowsInSection:section] - 1;

    if (row >= 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark -
#pragma mark - Group Messages

- (NSMutableArray *)grouppedMessages
{
    NSMutableArray *conversation = [NSMutableArray new];
    
    if (![self intervalForMessagesGrouping])
    {
        if ([self messages])
        {
            [conversation addObject:[self messages]];
        }
    }
    else
    {
        int groupIndex = 0;
        
        NSMutableArray *allMessages = [self messages];

        for (int i = 0; i < allMessages.count; i++)
        {
            if (i == 0)
            {
                NSMutableArray *firstGroup = [NSMutableArray new];
                [firstGroup addObject:allMessages[i]];
                [conversation addObject:firstGroup];
            }
            else
            {
                id<CLFMessage> prevMessage    = allMessages[i-1];
                id<CLFMessage> currentMessage = allMessages[i];
                
                NSDate *prevMessageDate    = prevMessage.date;
                NSDate *currentMessageDate = currentMessage.date;
                
                NSTimeInterval interval = [currentMessageDate timeIntervalSinceDate:prevMessageDate];
                
                if (interval < [self intervalForMessagesGrouping])
                {
                    NSMutableArray *group = conversation[groupIndex];
                    [group addObject:currentMessage];
                    
                }
                else
                {
                    NSMutableArray *newGroup = [NSMutableArray new];
                    [newGroup addObject:currentMessage];
                    [conversation addObject:newGroup];
                    groupIndex++;
                }
            }
        }
    }
    
    return conversation;
}


#pragma mark -
#pragma mark - CLFMessaging delegate

- (void)messageCell:(CLFMessageCell *)cell didTapMedia:(NSData *)media
{
    [self didSelectMedia:media inMessageCell:cell];
}

- (void)didSelectMedia:(NSData *)media inMessageCell:(CLFMessageCell *)cell
{
    if (cell.message.type == CLFMessageTypePhoto)
    {
        self.imageBrowser = [[CLFImageBrowserView alloc] init];
        self.imageBrowser.image = [UIImage imageWithData:cell.message.media];
        self.imageBrowser.startFrame = [cell convertRect:cell.containerView.frame toView:self.view];
        [self.imageBrowser show];
    }
    else if (cell.message.type == CLFMessageTypeVideo)
    {
        NSString *appFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"video.mp4"];
        [cell.message.media writeToFile:appFile atomically:YES];

        self.moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:appFile]];
        [self.moviePlayerController.moviePlayer prepareToPlay];
        [self.moviePlayerController.moviePlayer setShouldAutoplay:YES];

        [self presentViewController:self.moviePlayerController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    else if (cell.message.type == CLFMessageTypeAudio)
    {
        NSLog(@"selected audio on cell");
    }
    else if (cell.message.type == CLFMessageTypeLocation)
    {
        NSLog(@"selected location on cell");
    }
}


#pragma mark - Helper methods : for a balloons
- (UIImage *)tintImage:(UIImage *)image withColor:(UIColor *)color border:(UIColor*) borderColor
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    
//    [borderColor setStroke];
//    CGContextSetLineWidth(context, 2.0);
//    CGContextStrokeRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket
{
    NSLog(@"TURN Connection succeeded!");
    NSLog(@"You now have a socket that you can use to send/receive data to/from the other person.");
    
    [turnSockets removeObject:sender];
}

- (void)turnSocketDidFail:(TURNSocket *)sender
{
    NSLog(@"TURN Connection failed!");
    [turnSockets removeObject:sender];
    
}



@end
