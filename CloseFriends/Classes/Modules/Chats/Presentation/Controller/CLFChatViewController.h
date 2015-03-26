/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFMessagingViewController.h"
#import "CLFMacros.h"
#import "CLFChatMessageInputViewController.h"
#import "CLFAssetPickerController.h"

@protocol CLFChatInterface;

@interface CLFChatViewController : CLFMessagingViewController <UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, CLFChatMessageInputViewControllerDelegate, CLFAssetPickerControllerDelegate>
{
    UIPanGestureRecognizer *panGesture;
    UITapGestureRecognizer *tapGesture;
    UIViewAnimationCurve keyboardCurve;
    CGRect keyboardFrame;
    double keyboardDuration;
}

//Chat interface(partner name, status, last message)
@property (nonatomic, strong) id<CLFChatInterface> chat;

@property(nonatomic, strong) CLFAssetPickerController* customAssetPickerController;

@property (nonatomic) CGFloat textInitialHeight;
@property (nonatomic) CGFloat textMaxHeight;
@property (nonatomic) CGFloat textTopMargin;
@property (nonatomic) CGFloat textBottomMargin;
@property (nonatomic) CGFloat textleftMargin;
@property (nonatomic) CGFloat textRightMargin;

#pragma mark - Methods
- (void)adjustPosition;
- (void)adjustTextViewSize;
- (void)adjustTableViewWithCurve:(BOOL)withCurve scrollsToBottom:(BOOL)scrollToBottom;


@end
