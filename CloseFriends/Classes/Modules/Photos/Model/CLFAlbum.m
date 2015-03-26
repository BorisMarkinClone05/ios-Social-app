/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFAlbum.h"

@interface CLFAlbum ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSArray *mediaItems;
@property (nonatomic, strong) NSArray *contacts;

@end

@implementation CLFAlbum

#pragma mark - Initialization

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = [name copy];
        _creationDate = [NSDate date];
        _mediaItems = [[NSArray alloc] init];
        _contacts = [[NSArray alloc] init];
    }
    return self;
}

#pragma mark - Public methods
- (NSString *)creationDateAsString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd / MM / yyyy";
    return [dateFormatter stringFromDate:self.creationDate];
}

- (void)addPhotos:(NSArray *)photos {
    if (photos && photos.count > 0) {
        self.mediaItems = [self.mediaItems arrayByAddingObjectsFromArray:photos];
    }
}

- (void)shareWithContacts:(NSArray *)contacts {
    if (contacts && contacts.count > 0) {
        self.contacts = [self.contacts arrayByAddingObjectsFromArray:contacts];
    }
}

- (void)removeContacts:(NSArray *)contacts {
    if (contacts && contacts.count > 0) {
        NSMutableArray *allContacts = [self.contacts mutableCopy];
        [allContacts removeObjectsInArray:contacts];
        self.contacts = allContacts;
    }
}

@end