/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFAssetPickerController.h"

@interface CLFAssetPickerController ()

@end


@implementation CLFAssetPickerController

@synthesize filterType = _filterType;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
