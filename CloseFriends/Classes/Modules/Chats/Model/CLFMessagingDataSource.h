/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>

@class CLFMessageCell;
@protocol CLFMessagingDataSource <NSObject>

@required

// Array of CLFMessage objects.
- (NSMutableArray*) messages;

// Override this method if you want to customize cell that will be shown.
// This method calls after cell default adjustment on every reuse time
- (void) configureMessageCell:(CLFMessageCell *)cell forMessageAtIndex:(NSInteger)index;

@optional

// Default implementation of this method is calculating height of the cell for message at given index.
- (CGFloat) heightForMessageForIndex:(NSInteger)index;

// Messages will be grouped by returned time interval (in seconds).
// return 0 if you don't want grouping.
- (NSTimeInterval) intervalForMessagesGrouping;

// Return resizable image for sending balloon background image
- (UIImage*) balloonImageForSending;

// Return resizable image for receiving balloon background image
- (UIImage*) balloonImageForReceiving;

// Maximum width of message
- (CGFloat) messageMaxWidth;

// Minimum height of balloon
- (CGFloat) balloonMinHeight;

// Minimum width of balloon
- (CGFloat) balloonMinWidth;

// Font of message
- (UIFont*) messageFont;

// Size of photo or video thumbnail imageView
- (CGSize) mediaThumbnailSize;

// Size user's imageview
- (CGSize) userImageSize;


 @end
