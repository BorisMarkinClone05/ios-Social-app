/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFChatsAdapter.h"
#import "CLFChatCell.h"
#import "CLFChatsSectionHeaderView.h"

#import "CLFChatInterface.h"
#import "CLFChatGroupInterface.h"
#import "CLFMacros.h"

static NSString * const ChatCellIdentifier = @"CLFChatCell";
static NSString * const ChatsSectionHeaderIdentifier = @"CLFChatsSectionHeaderView";

@interface CLFChatsAdapter ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *chatGroups;

@end

@implementation CLFChatsAdapter

#pragma mark - Initialization

- (instancetype)initWithTableView:(UITableView *)tableView
                       chatGroups:(NSArray *)chatGroups {
    self = [super init];
    if (self) {
        self.tableView = tableView;
        
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFChatCell class])
                                                   bundle:nil]
             forCellReuseIdentifier:ChatCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLFChatsSectionHeaderView class])
                                                   bundle:nil] forHeaderFooterViewReuseIdentifier:ChatsSectionHeaderIdentifier];
        
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 8, 0.0, 0.0);
        self.tableView.separatorColor = UIColorFromRGB(0xC8C8C8);
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self.chatGroups = chatGroups;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *groupChats = [self.chatGroups[section] chats];
    return groupChats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *groupChats = [self.chatGroups[indexPath.section] chats];
    
    CLFChatCell *cell = (CLFChatCell *)[tableView dequeueReusableCellWithIdentifier:ChatCellIdentifier
                                                                       forIndexPath:indexPath];
    [cell configureWithChat:groupChats[indexPath.row]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.chatGroups.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.editing;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.commitEditingStyleBlock) {
        self.commitEditingStyleBlock(tableView, editingStyle, indexPath);
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CLFChatsSectionHeaderView *header = (CLFChatsSectionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:ChatsSectionHeaderIdentifier];
    [header configureWithChatGroup:self.chatGroups[section]];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(tableView, indexPath);
    }
}

#pragma mark -

@end
