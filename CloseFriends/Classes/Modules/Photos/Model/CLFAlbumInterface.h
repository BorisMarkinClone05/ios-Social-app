/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


@import Foundation;

@protocol CLFAlbumInterface <NSObject>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) NSDate *creationDate;
@property (nonatomic, readonly) NSArray *mediaItems;
@property (nonatomic, readonly) NSArray *contacts;

@property (nonatomic, readonly) NSString *creationDateAsString;

@end