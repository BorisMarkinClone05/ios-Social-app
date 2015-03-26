/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import Foundation;

#import "CLFAlbumInterface.h"

@interface CLFAlbum : NSObject <CLFAlbumInterface>

- (instancetype)initWithName:(NSString *)name;

- (void)addPhotos:(NSArray *)photos;
- (void)shareWithContacts:(NSArray *)contacts;
- (void)removeContacts:(NSArray *)contacts;

@end