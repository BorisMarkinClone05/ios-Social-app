/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import <UIKit/UIKit.h>
#import "CLFMessage.h"

#define kBubbleTopMargin 0
#define kBubbleLeftMargin 7
#define kBubbleRightMargin 7
#define kBubbleBottomMargin 20

@class CLFMessageCell;


@protocol CLFMessageCellDelegate <NSObject>

@optional
- (void)messageCell:(CLFMessageCell *)cell didTapMedia:(NSData *)media;
@end


@interface CLFMessageCell : UITableViewCell

@property(weak, nonatomic) id<CLFMessage> message;
@property(weak, nonatomic) id<CLFMessageCellDelegate> delegate;

@property(weak, nonatomic) UITableView *tableView;

@property(strong, nonatomic) UIView *mediaOverlayView;
@property(strong, nonatomic) UIView *containerView;

@property(strong, nonatomic) UIImageView *userImageView;
@property(strong, nonatomic) UIImageView *mediaImageView;
@property(strong, nonatomic) UIImageView *balloonImageView;

@property(strong, nonatomic) UITextView *textView;

@property(strong, nonatomic) UILabel *timeLabel;

@property(weak, nonatomic) UIImage *balloonImage;
@property(weak, nonatomic) UIImage *userImage;

@property(strong, nonatomic) UIFont *messageFont;

@property(strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property(nonatomic) UIEdgeInsets contentInsets;

@property(nonatomic) CGFloat balloonMinWidth;
@property(nonatomic) CGFloat balloonMinHeight;
@property(nonatomic) CGFloat messageMaxWidth;


+ (CGFloat) messageTopMargin;
+ (void) setMessageTopMargin:(CGFloat)margin;
+ (CGFloat) messageBottomMargin;
+ (void) setMessageBottomMargin:(CGFloat)margin;
+ (CGFloat) messageLeftMargin;
+ (void) setMessageLeftMargin:(CGFloat)margin;
+ (CGFloat) messageRightMargin;
+ (void) setMessageRightMargin:(CGFloat)margin;
+ (CGFloat) maxContentOffsetX;
+ (void) setMaxContentOffsetX:(CGFloat)offsetX;
+ (void)setDefaultConfigs;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier messageMaxWidth:(CGFloat)messageMaxWidth;
- (void)setMediaImageViewSize:(CGSize)size;
- (void)setUserImageViewSize:(CGSize)size;
- (void)adjustCell;

@end
