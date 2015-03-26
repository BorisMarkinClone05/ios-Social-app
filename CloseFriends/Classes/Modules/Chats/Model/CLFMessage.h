/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>
#import "CLFMessageType.h"

@import UIKit;

@protocol CLFMessage

// Message text
@property (strong, nonatomic) NSString *text;

// Attributes for attributed message text
@property (strong, nonatomic) NSDictionary *attributes;

// NSData from photo or video
@property (strong, nonatomic) NSData *media;

// Default thumbnail for media.
@property (strong, nonatomic) UIImage *thumbnail;

// Message sent date, Messages will be sorted by this property
@property (strong, nonatomic) NSDate *date;

// Boolean value that indicates who is the sender, This is important property and will be used to decide in which side show message.
@property (nonatomic) BOOL fromMe;

// Type of message. Available values: CLFMessageTypeText, CLFMessageTypePhoto, CLFMessageTypeVideo, CLFMessageTypeAudio, CLFMessageTypeLocation
@property (nonatomic) CLFMessageType type;

@end
