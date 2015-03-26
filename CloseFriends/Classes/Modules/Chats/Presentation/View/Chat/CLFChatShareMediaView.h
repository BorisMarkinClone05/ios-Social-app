/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CLFMediaType) {
    CLFMediaTypePhoto = 0,
    CLFMediaTypeAlbum,
    CLFMediaTypeLocation,
    CLFMediaTypeVideo
};

@interface CLFChatShareMediaView : UIView

@property (nonatomic, copy) void(^didSelectMediaBlock)(CLFMediaType mediaType);

+ (instancetype)view;

@end
