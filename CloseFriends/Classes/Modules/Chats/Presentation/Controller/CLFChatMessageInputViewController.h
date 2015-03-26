/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>
#import "CLFChatMessageTextView.h"
#import "CLFChatMessageInputView.h"
#import "CLFMacros.h"
#import "CLFChatShareMediaView.h"


@class CLFChatMessageInputView;


@protocol CLFChatMessageInputViewControllerDelegate <NSObject>

@optional
- (void)sendTextMessageFromInputView;
- (void)openCameraFromInputView;
- (void)openRecordFromInputView;
- (void)openMediaWithType:(NSInteger) mediaType;
@end


@interface CLFChatMessageInputViewController : NSObject

@property (nonatomic, weak) id <CLFChatMessageInputViewControllerDelegate> delegate;
@property (nonatomic, strong) CLFChatMessageTextView *messageTextView;
@property (nonatomic, strong) CLFChatMessageInputView *messageInputView;

- (instancetype)initWithInputView:(CLFChatMessageInputView *)inputView;

@end
