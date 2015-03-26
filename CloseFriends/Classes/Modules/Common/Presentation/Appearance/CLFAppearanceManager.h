/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

@import Foundation;

#import "CLFTheme.h"

@interface CLFAppearanceManager : NSObject

@property (nonatomic, strong) id<CLFTheme> currentTheme;

+ (instancetype)sharedInstance;

@end
