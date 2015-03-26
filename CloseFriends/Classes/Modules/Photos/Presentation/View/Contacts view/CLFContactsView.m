/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFContactsView.h"
#import "CLFCircleContactView.h"

@interface CLFContactsView ()

@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *contactsViews;

@end

@implementation CLFContactsView

#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _sideSize = 0;
    _interSpacing = 2.0f;
    _maxNumberOfVisibleContacts = 3;
    _contactsViews = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.contactsViews.count > 0) {
        NSInteger numberOfSpaces = self.contactsViews.count - 1;
        CGFloat sideSize = _sideSize > 0 ? _sideSize : (self.bounds.size.width - self.interSpacing * numberOfSpaces) / self.contactsViews.count;
        CGFloat y = (self.bounds.size.height - sideSize) / 2.0f;

        for (NSInteger i = 0; i < self.contactsViews.count; i++) {
            CLFCircleContactView *contactView = self.contactsViews[i];
            contactView.frame = CGRectMake(i * (sideSize + self.interSpacing) , y, sideSize, sideSize);
            if (contactView.imageView.hidden) {
                contactView.label.font = [contactView.label.font fontWithSize:sideSize / 2.4f];
            }
        }
    }
}

#pragma mark - Public methods

- (void)updatedContacts:(NSArray *)contacts {
    self.contacts = contacts;
    [self updateContactsViews];
}

- (void)setMaxNumberOfVisibleContacts:(NSUInteger)maxNumberOfVisibleContacts {
    [self willChangeValueForKey:@"maxNumberOfVisibleContacts"];
    _maxNumberOfVisibleContacts = maxNumberOfVisibleContacts;
    [self didChangeValueForKey:@"maxNumberOfVisibleContacts"];
    [self updateContactsViews];
}

#pragma mark - Private methods
- (void)updateContactsViews {
    [self clearContactViews];

    if (self.contacts.count > 0) {
        NSInteger numberOfVisibleContacts = self.contacts.count;
        if (0 < self.maxNumberOfVisibleContacts  && self.maxNumberOfVisibleContacts < self.contacts.count) {
            numberOfVisibleContacts = self.maxNumberOfVisibleContacts;
        }

        for (NSInteger i = 0; i < numberOfVisibleContacts; i ++) {
            CLFCircleContactView *contactView = [[CLFCircleContactView alloc] init];
            if (i == numberOfVisibleContacts - 1 &&
                    numberOfVisibleContacts == self.maxNumberOfVisibleContacts &&
                    numberOfVisibleContacts < self.contacts.count) {
                contactView.imageView.hidden = YES;
                contactView.label.text = [NSString stringWithFormat:@"+%ld", (long) (self.contacts.count - self.maxNumberOfVisibleContacts + 1)];
            } else {
                //TODO:Change when will changed contact class
                contactView.imageView.image = [UIImage imageNamed:@"contact_icon"];
            }
            [self addSubview:contactView];
            [self.contactsViews addObject:contactView];
        }
    }
}

- (void)clearContactViews {
    for (UIView *view in self.contactsViews) {
        [view removeFromSuperview];
    }
    [self.contactsViews removeAllObjects];
}

@end