//
//  HWFriendCell.h
//  HealthyWay
//
//  Created by Anastasia Mark on 17.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HWFriendCellType) {
    HWFriendCellTypeRequestedFriend,
    HWFriendCellTypeRequestingFriend,
    HWFriendCellTypeExistedFriend
};

@protocol HWFriendCellDelegate;

@interface HWFriendCell : UITableViewCell

@property (weak, nonatomic) id<HWFriendCellDelegate> delegate;

- (void)selectAddFriendButton:(BOOL)select;
- (void)hideAddFriendButton:(BOOL)hide;

- (void)configureWithNameLabelText:(NSString *)nameLabelText
                         avatarURL:(NSURL *)avatarURL
                      searchedText:(NSString *)searchedText
                       forCellType:(HWFriendCellType)type;
- (void)configureWithNameLabelText:(NSString *)nameLabelText
                         avatarURL:(NSURL *)avatarURL
                       forCellType:(HWFriendCellType)type;

@end

@protocol HWFriendCellDelegate <NSObject>

@optional
- (void)friendCell:(HWFriendCell *)cell didTapAddFriendButton:(UIButton *)button;
- (void)friendCellDidTapAcceptRequestingFriendButton:(HWFriendCell *)cell;
- (void)friendCellDidTapDenyRequestingFriendButton:(HWFriendCell *)cell;

@end