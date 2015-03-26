/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "AppDelegate.h"

#import "CLFAppearanceManager.h"
#import "CLFDefaultTheme.h"

#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"


#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


@interface AppDelegate ()

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end


@implementation AppDelegate

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [self requestDeviceToken];
    
    [[CLFAppearanceManager sharedInstance] setCurrentTheme:[CLFDefaultTheme new]];
    
    // Configure logging framework
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
    
    // Setup the XMPP stream
    [self setupStream];
    
    defaults = [NSUserDefaults standardUserDefaults];

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc
{

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
#if TARGET_IPHONE_SIMULATOR
    DDLogError(@"The iPhone simulator does not process background network traffic. "
               @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
    if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
    {
        [application setKeepAliveTimeout:600 handler:^{
            
            DDLogVerbose(@"KeepAliveHandler");
            
            // Do other keep alive stuff here.
        }];
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[self xmppStream] isDisconnected])
    {
        if(![self connect])
        {
            [self createXMPPAccount];
        }
    }
    else
    {
        [self goOnline];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    [self teardownStream];
}


#pragma mark - 
#pragma mark - XMPP

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        // Want xmpp to run in the background?
        //
        // P.S. - The simulator doesn't support backgrounding yet.
        //        When you try to set the associated property on the simulator, it simply fails.
        //        And when you background an app on the simulator,
        //        it just queues network traffic til the app is foregrounded again.
        //        We are patiently waiting for a fix from Apple.
        //        If you do enableBackgroundingOnSocket on the simulator,
        //        you will simply see an error message from the xmpp stack when it fails to set the property.
        
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
    xmppReconnect = [[XMPPReconnect alloc] init];
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    [xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    [xmppvCardTempModule   activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
    [xmppCapabilities      activate:xmppStream];
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [xmppStream setHostName:XMPP_SERVER_IP];
	[xmppStream setHostPort:5222];
    
    customCertEvaluation = YES;
}

- (void)teardownStream
{
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    [xmppReconnect         deactivate];
    [xmppRoster            deactivate];
    [xmppvCardTempModule   deactivate];
    [xmppvCardAvatarModule deactivate];
    [xmppCapabilities      deactivate];
    
    [xmppStream disconnect];
    
    xmppStream = nil;
    xmppReconnect = nil;
    xmppRoster = nil;
    xmppRosterStorage = nil;
    xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
    xmppvCardAvatarModule = nil;
    xmppCapabilities = nil;
    xmppCapabilitiesStorage = nil;
}

- (void)goOnline
{
    NSLog(@"**************************************");
    NSLog(@"go online");
    NSLog(@"**************************************");


    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
    
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
    NSLog(@"**************************************");
    NSLog(@"go offline");
    NSLog(@"**************************************");

    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
    NSLog(@"**************************************");
    NSLog(@"try to connect xmpp");
    NSLog(@"**************************************");

    if ([xmppStream isConnected])
    {
        return YES;
    }
    
    jidID = [defaults stringForKey:@"myJID"];
    password = [defaults stringForKey:@"myPassword"];
    
    if (jidID == nil || password == nil)
    {
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:jidID]];
    
    NSError *error = nil;
    
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        DDLogError(@"Error connecting: %@", error);
        
        return NO;
    }
    
    return YES;
}

- (void)disconnect
{
    NSLog(@"**************************************");
    NSLog(@"try to disconnect");
    NSLog(@"**************************************");

    [self goOffline];
    [xmppStream disconnect];
}

- (void)createXMPPAccount
{
    //register new user for OPENFIRE server
//    NSString *myJID = [defaults stringForKey:@"myJID"];
//    password = [defaults stringForKey:@"myPassword"];
    
    jidID = @"boris1@chat.closefriends.com";
    password = @"pass123";
    
    xmppStream.myJID = [XMPPJID jidWithString:jidID];
    
    NSError *error = nil;
    BOOL success;
    
    if(![[self xmppStream] isConnected])
    {
        success = [xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
        
        if (success)
        {
//            success = [xmppStream registerWithPassword:password error:&error];
            
            NSMutableArray *elements = [NSMutableArray array];
            [elements addObject:[NSXMLElement elementWithName:@"username" stringValue:xmppStream.myJID.user]];
            [elements addObject:[NSXMLElement elementWithName:@"password" stringValue:password]];
            //        [elements addObject:[NSXMLElement elementWithName:@"name" stringValue:[defaults stringForKey:@"profileName"]]];
            //        [elements addObject:[NSXMLElement elementWithName:@"deviceToken" stringValue:[defaults stringForKey:@"token"]]];
            //        [elements addObject:[NSXMLElement elementWithName:@"email" stringValue:[defaults stringForKey:@"email"]]];
            
            success = [xmppStream registerWithElements:elements error:&error];
            
            if (error)
            {
                NSLog(@"send register request failed:%@", error.description);
            }
        }
    }
    else
    {
//        success = [xmppStream registerWithPassword:password error:&error];
        
        NSMutableArray *elements = [NSMutableArray array];
        [elements addObject:[NSXMLElement elementWithName:@"username" stringValue:xmppStream.myJID.user]];
        [elements addObject:[NSXMLElement elementWithName:@"password" stringValue:password]];
//        [elements addObject:[NSXMLElement elementWithName:@"name" stringValue:[defaults stringForKey:@"profileName"]]];
//        [elements addObject:[NSXMLElement elementWithName:@"deviceToken" stringValue:[defaults stringForKey:@"token"]]];
//        [elements addObject:[NSXMLElement elementWithName:@"email" stringValue:[defaults stringForKey:@"email"]]];
        
        success = [xmppStream registerWithElements:elements error:&error];
        
        if (error)
        {
            NSLog(@"send register request failed:%@", error.description);
        }
    }
    
    if (success)
    {
        isRegistering = YES;
        
//        [defaults setObject:jidID forKey:@"myJID"];
//        [defaults setObject:password forKey:@"myPassword"];
//        [defaults synchronize];
        
        NSLog(@"**************************************");
        NSLog(@"sent register request succesful");
        NSLog(@"**************************************");

    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    NSLog(@"**************************************");
    NSLog(@"xmpp socketDidConnect");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    NSLog(@"**************************************");
    NSLog(@"xmpp willSecureWithSettings");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString *expectedCertName = [xmppStream.myJID domain];
    if (expectedCertName)
    {
        settings[(NSString *) kCFStreamSSLPeerName] = expectedCertName;
    }
    
    if (customCertEvaluation)
    {
        settings[GCDAsyncSocketManuallyEvaluateTrust] = @(YES);
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    NSLog(@"**************************************");
    NSLog(@"xmpp didReceiveTrust");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // The delegate method should likely have code similar to this,
    // but will presumably perform some extra security code stuff.
    // For example, allowing a specific self-signed certificate that is known to the app.
    
    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bgQueue, ^{
        
        SecTrustResultType result = kSecTrustResultDeny;
        OSStatus status = SecTrustEvaluate(trust, &result);
        
        if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    });
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    NSLog(@"**************************************");
    NSLog(@"xmpp xmppStreamDidSecure");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"**************************************");
    NSLog(@"xmpp xmppStreamDidConnect");
    NSLog(@"**************************************");
    
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    isXmppConnected = YES;
    
    NSError *error = nil;
    
    jidID = [defaults stringForKey:@"myJID"];
    password = [defaults stringForKey:@"myPassword"];
    
    if (jidID == nil || password == nil)//not registered
    {
        NSMutableArray *elements = [NSMutableArray array];
        [elements addObject:[NSXMLElement elementWithName:@"username" stringValue:xmppStream.myJID.user]];
        [elements addObject:[NSXMLElement elementWithName:@"password" stringValue:password]];
//        [elements addObject:[NSXMLElement elementWithName:@"name" stringValue:[defaults stringForKey:@"profileName"]]];
//        [elements addObject:[NSXMLElement elementWithName:@"accountType" stringValue:@"3"]];
//        [elements addObject:[NSXMLElement elementWithName:@"deviceToken" stringValue:[defaults stringForKey:@"token"]]];
//        [elements addObject:[NSXMLElement elementWithName:@"email" stringValue:[defaults stringForKey:@"email"]]];
        
        [[self xmppStream] registerWithElements:elements error:&error];
        
        if (error)
        {
            NSLog(@"send register request failed:%@", error.description);
        }

        isRegistering = YES;
    }
    else
    {
        if (![[self xmppStream] authenticateWithPassword:password error:&error])
        {
            DDLogError(@"Error authenticating: %@", error);
        }
        else
        {
            NSLog(@"**************************************");
            NSLog(@"sent authentication request");
            NSLog(@"**************************************");
        }
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"**************************************");
    NSLog(@"xmpp xmppStreamDidRegister");
    NSLog(@"**************************************");

    [defaults setObject:jidID forKey:@"myJID"];
    [defaults setObject:password forKey:@"myPassword"];
    [defaults synchronize];

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // Update tracking variables
    isRegistering = NO;
    
    [[self xmppStream] authenticateWithPassword:password error:nil];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"**************************************");
    NSLog(@"xmpp didNotRegister");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // Update tracking variables
    isRegistering = NO;
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"**************************************");
    NSLog(@"xmpp xmppStreamDidAuthenticate");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"**************************************");
    NSLog(@"xmpp didNotAuthenticate");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString* myJID = [[NSUserDefaults standardUserDefaults] objectForKey:@"myJID"];
    NSString* myPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"myPassword"];
    
    if ((myJID == nil) || (myPassword == nil))
    {
        [self createXMPPAccount];
    }
    else
    {
        [[self xmppStream] authenticateWithPassword:password error:nil];
    }

}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSLog(@"**************************************");
    NSLog(@"xmpp didReceiveIQ");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"**************************************");
    NSLog(@"xmpp didReceiveMessage");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
//    NSString *msg = [[message elementForName:@"body"] stringValue];
//    NSString *from = [[message attributeForName:@"from"] stringValue];
//    
//    NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
//    [m setObject:msg forKey:@"msg"];
//    [m setObject:from forKey:@"sender"];
//    
//    [_messageDelegate newMessageReceived:m];
//    [m release];
//    
//    // A simple example of inbound message handling.
//    
//    if ([message isChatMessageWithBody])
//    {
//        XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
//                                                                 xmppStream:xmppStream
//                                                       managedObjectContext:[self managedObjectContext_roster]];
//        
//        NSString *body = [[message elementForName:@"body"] stringValue];
//        NSString *senderName = [user displayName];
//        XMPPJID *chatJID = [message from];
//        
//        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
//        body = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
//        
//        NSString *chatMessage = @"";
//        NSRange nameRange = [body rangeOfString:@":"];
//        if(nameRange.location != NSNotFound){
//            NSUInteger seperateIndex = nameRange.location;
//            senderName = [body substringToIndex:seperateIndex];
//            chatMessage = [body substringFromIndex:seperateIndex + 1];
//        }
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"getChatMessages" object:nil];
//        
////        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
////        {
////            IIViewDeckController *deckVC = (IIViewDeckController *)self.window.rootViewController;
////            UINavigationController* mainVC = (UINavigationController *)deckVC.centerController;
////            if (mainVC && [mainVC isKindOfClass:[UINavigationController class]] && [mainVC.visibleViewController isKindOfClass:[NotificationsViewController class]])
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"getNotificationCounts" object:nil];
////            
////            if (mainVC && [mainVC isKindOfClass:[UINavigationController class]] && [mainVC.visibleViewController isKindOfClass:[ChatDetailViewController class]])
////            {
////                NSString *imagePath = @"";
////                NSString *subject = [[message elementForName:@"subject"] stringValue];
////                NSRange subjectRange = [subject rangeOfString:@":"];
////                if(subjectRange.location != NSNotFound){
////                    NSUInteger seperateIndex = subjectRange.location;
////                    imagePath = [subject substringFromIndex:seperateIndex + 1];
////                }
////                
////                NSLog(@"Visible ChatDetailViewController");
////                ChatDetailViewController *chatDetailVC = (ChatDetailViewController *)mainVC.topViewController;
////                if ([chatDetailVC.peopleID isEqualToString:chatJID.user])
////                    [chatDetailVC reloadChatContents:YES withMessage:chatMessage Path:imagePath];
////                else
////                    [chatDetailVC showChatNotifiView:chatMessage];
////                
////                [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
////                [self setNotificationCount:[NSNumber numberWithInt:1] withCount:0];
////                
////            } else {
////                
////                if (chatMessage.length > 50) {
////                    NSRange range;
////                    range.location = 0;
////                    range.length = 50;
////                    NSString *subString = [chatMessage substringWithRange:range];
////                    chatMessage = [subString stringByAppendingString:@"..."];
////                }
////                
////                _vAlert = [[DoAlertView alloc] init];
////                _vAlert.nAnimationType = 3;
////                _vAlert.dRound = 2.0;
////                _vAlert.bDestructive = NO;
////                [_vAlert doYesNo:senderName body:chatMessage
////                             yes:^(DoAlertView *alertView) {
////                                 
////                                 [self goToChatFromPush:chatJID.user :senderName];
////                                 
////                             } no:^(DoAlertView *alertView) {
////                                 
////                             }];
////                _vAlert = nil;
////                
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotificationsBadge" object:nil];
////            }
////        }
////        else
////        {
////            // We are not active, so use a local notification instead
////            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
////            localNotification.alertAction = @"Ok";
////            localNotification.alertBody = body;
////            localNotification.userInfo = @{@"profileID": chatJID.user};
////            
////            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
////        }
//    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSLog(@"**************************************");
    NSLog(@"xmpp didReceivePresence");
    NSLog(@"**************************************");
    
    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:myUsername])
    {
        NSLog(@"found a friend");
        
        if ([presenceType isEqualToString:@"available"])
        {
            NSLog(@"a friend is available");
            
//            [_chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"]];
            
        }
        else if ([presenceType isEqualToString:@"unavailable"])
        {
            NSLog(@"a friend is unavailable");

//            [_chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"]];
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    NSLog(@"**************************************");
    NSLog(@"xmpp didReceiveError");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"**************************************");
    NSLog(@"xmpp xmppStreamDidDisconnect");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if (!isXmppConnected)
    {
        DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
    }
    
    isRegistering = NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
    NSLog(@"**************************************");
    NSLog(@"xmpp didReceiveBuddyRequest");
    NSLog(@"**************************************");

    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
                                                             xmppStream:xmppStream
                                                   managedObjectContext:[self managedObjectContext_roster]];
    
    NSString *displayName = [user displayName];
    NSString *jidStrBare = [presence fromStr];
    NSString *body = nil;
    
    if (![displayName isEqualToString:jidStrBare])
    {
        body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
    }
    else
    {
        body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
    }
    
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                            message:body
                                                           delegate:nil
                                                  cancelButtonTitle:@"Not implemented"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Not implemented";
        localNotification.alertBody = body;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
    
}


#pragma mark - 
#pragma mark - 

-(void)requestDeviceToken
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                            |UIRemoteNotificationTypeSound
                                            |UIRemoteNotificationTypeAlert)
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

-(void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

-(void) application:(UIApplication*) application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    
}


-(void) application:(UIApplication*) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSLog(@"token:%@", token);
}

//-(void) userSignup
//{
//    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
//    
//    NSDictionary* signingDic = @{@"phone_number": @"79999999927"};
//    
//    [manager POST:@"http://api.closefriends.com/api/v1/auth_tokens" parameters:signingDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSMutableArray* dicArray = [responseObject objectForKey:@"auth_token"];
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"signing failed");
//        
//    }];
//    
//    //        POST /api/v1/auth_tokens
//    //        {
//    //            "phone_number": "+7 999 999 99 27"
//    //        }
//    //        201
//    //        {
//    //            "auth_token": {
//    //                "token": "6c185ab7-277a-4cc3-83e4-138851f2f3c2",
//    //                "expiried_at": "2015-02-22T22:03:51.118Z",
//    //                "state": "unconfirmed"
//    //            }
//    //        }
//
//}
//
@end
