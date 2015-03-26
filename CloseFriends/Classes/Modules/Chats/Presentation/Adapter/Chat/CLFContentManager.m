/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFContentManager.h"
#import "CLFChatMessage.h"
#import "CLFMessageType.h"

@implementation CLFContentManager

+ (CLFContentManager *)sharedManager
{
    static CLFContentManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (NSArray *)generateConversation
{
    NSMutableArray *result = [NSMutableArray new];
    NSArray *data = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Conversation" ofType:@"plist"]]];
    
    for (NSDictionary *msg in data)
    {
        CLFChatMessage *message = [[CLFChatMessage alloc] init];
        message.fromMe = [msg[@"fromMe"] boolValue];
        message.text = msg[@"message"];
        message.type = [self messageTypeFromString:msg[@"type"]];
        message.date = [NSDate date];
        
        int index = (int)[data indexOfObject:msg];
        
        if (index > 0)
        {
            CLFChatMessage *prevMesage = result.lastObject;
            message.date = [NSDate dateWithTimeInterval:((index % 2) ? 2 * 24 * 60 * 60 : 120) sinceDate:prevMesage.date];
        }
        
        if (message.type == CLFMessageTypePhoto)
        {
            message.media = UIImageJPEGRepresentation([UIImage imageNamed:msg[@"image"]], 1);
        }
        else if (message.type == CLFMessageTypeVideo)
        {
            message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:msg[@"video"] ofType:@"mp4"]];
            message.thumbnail = [UIImage imageNamed:msg[@"thumbnail"]];
        }

        [result addObject:message];
    }
    
    return result;
}

- (CLFMessageType)messageTypeFromString:(NSString *)string
{
    if ([string isEqualToString:@"CLFMessageTypeText"])
    {
        return CLFMessageTypeText;
    }
    else if ([string isEqualToString:@"CLFMessageTypePhoto"])
    {
        return CLFMessageTypePhoto;
    }
    else if ([string isEqualToString:@"CLFMessageTypeVideo"])
    {
        return CLFMessageTypeVideo;
    }
    else if ([string isEqualToString:@"CLFMessageTypeAudio"])
    {
        return CLFMessageTypeAudio;
    }
    else if ([string isEqualToString:@"CLFMessageTypeLocation"])
    {
        return CLFMessageTypeLocation;
    }

    return CLFMessageTypeOther;
}

@end
