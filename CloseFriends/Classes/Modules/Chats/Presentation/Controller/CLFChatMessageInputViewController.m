/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChatMessageInputViewController.h"

@interface CLFChatMessageInputViewController ()

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *closeShareModeButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *audioRecordButton;
@property (nonatomic, strong) UIButton *sendMessageButton;

@end

@implementation CLFChatMessageInputViewController

#pragma mark - Initialization

- (instancetype)initWithInputView:(CLFChatMessageInputView *)inputView
{
    self = [super init];
    
    if (self)
    {
        self.messageInputView = inputView;
        
        [self configureMessageTextView];
        [self configureActionButtons];
        
        self.messageInputView.leftView = self.shareButton;
        self.messageInputView.inputView = self.messageTextView;
        self.messageInputView.rightViews = @[self.sendMessageButton];
    }
    
    return self;
}

#pragma mark - Configure UI

- (void)configureMessageTextView
{
    self.messageTextView = [CLFChatMessageTextView new];
    self.messageTextView.font = [UIFont fontWithName:@"Avenir-Medium" size:17.0];
    self.messageTextView.textColor = [UIColor blackColor];
    self.messageTextView.placeholder = @"Write Message";
    self.messageTextView.placeholderColor = UIColorFromRGB(0xC7C7CC);
    self.messageTextView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    self.messageTextView.minimumHeight = 30.0;
}

- (void)configureActionButtons
{
    self.shareButton = [self buttonWithImage:[UIImage imageNamed:@"shareIcon"]
                                      action:@selector(shareButtonTapped:)];
    
    self.closeShareModeButton = [self buttonWithImage:[UIImage imageNamed:@"closeIcon"]
                                               action:@selector(closeShareModeButtonTapped:)];
    
    self.cameraButton = [self buttonWithImage:[UIImage imageNamed:@"sendPhotoIcon"]
                                          action:@selector(cameraButtonTapped:)];
    
    self.audioRecordButton = [self buttonWithImage:[UIImage imageNamed:@"sendAudioIcon"]
                                          action:@selector(audioRecordButtonTapped:)];
    
    self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendMessageButton.backgroundColor = [UIColor clearColor];
    [self.sendMessageButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
                          forState:UIControlStateNormal];
    [self.sendMessageButton setTitleColor:[UIColor colorWithRed:0.0 green:65.0/255.0 blue:136.0/255.0 alpha:1.0]
                          forState:UIControlStateHighlighted];
    [self.sendMessageButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendMessageButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.0]];
    self.sendMessageButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.sendMessageButton addTarget:self action:@selector(sendMessageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Private

- (UIButton *)buttonWithImage:(UIImage *)image action:(SEL)action
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setImage:image forState:UIControlStateNormal];
    [bt addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return bt;
}


#pragma mark -
#pragma mark - Actions handling

- (void)shareButtonTapped:(id)sender
{
    self.messageInputView.leftView = self.closeShareModeButton;
    
    CLFChatShareMediaView *mediaView = [CLFChatShareMediaView view];
    mediaView.didSelectMediaBlock = ^(CLFMediaType mediaType) {
        [self openMedia:mediaType];
    };
    
    self.messageTextView.inputView = mediaView;
    [self.messageTextView resignFirstResponder];
    [self.messageTextView becomeFirstResponder];
    
    self.messageInputView.rightViews = @[self.cameraButton, self.audioRecordButton];
}

- (void)closeShareModeButtonTapped:(id)sender
{
    self.messageInputView.leftView = self.shareButton;
    self.messageTextView.inputView = nil;
    
    [self.messageTextView resignFirstResponder];
    [self.messageTextView becomeFirstResponder];
    
    self.messageInputView.rightViews = @[self.sendMessageButton];
}

- (void)sendMessageButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendTextMessageFromInputView)])
    {
        [self.delegate sendTextMessageFromInputView];
    }
}

- (void)cameraButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(openCameraFromInputView)])
    {
        [self.delegate openCameraFromInputView];
    }
}

- (void)audioRecordButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(openRecordFromInputView)])
    {
        [self.delegate openRecordFromInputView];
    }
}

- (void)openMedia:(NSInteger) mediaType
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(openMediaWithType:)])
    {
        [self.delegate openMediaWithType:mediaType];
    }
}


#pragma mark -

@end
