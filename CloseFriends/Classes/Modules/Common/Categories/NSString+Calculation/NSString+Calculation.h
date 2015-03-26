/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <Foundation/Foundation.h>
@import UIKit;

@interface NSString (Calculation)

- (CGSize)usedSizeForMaxWidth:(CGFloat)width withFont:(UIFont *)font;
- (CGSize)usedSizeForMaxWidth:(CGFloat)width withAttributes:(NSDictionary *)attributes;

@end
