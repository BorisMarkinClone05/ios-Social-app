/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChatShareMediaView.h"

@implementation CLFChatShareMediaView

#pragma mark - Initialization

+ (instancetype)view
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                  owner:nil
                                                options:nil];
    return nibs[0];
}

#pragma mark - Actions

- (IBAction)shareMediaButtonTapped:(id)sender
{
    if (self.didSelectMediaBlock)
    {
        self.didSelectMediaBlock([sender tag]);
    }
}

#pragma mark -

@end
