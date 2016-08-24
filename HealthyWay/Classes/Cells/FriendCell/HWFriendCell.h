//
//  HWFriendCell.h
//  HealthyWay
//
//  Created by Anastasia Mark on 17.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFriendCellConfigurationStrategy.h"

@protocol HWFriendCellDelegate;

@interface HWFriendCell : UITableViewCell

@property (weak, nonatomic) id<HWFriendCellDelegate> delegate;

@property (strong, nonatomic, readonly) id<HWFriendCellConfigurationStrategy> strategy;

- (void)selectAddFriendButton:(BOOL)select;
- (void)hideAddFriendButton:(BOOL)hide;

- (void)configureWithConfigurationStrategy:(id<HWFriendCellConfigurationStrategy>)strategy;

@end

@protocol HWFriendCellDelegate <NSObject>

@optional
- (void)friendCell:(HWFriendCell *)cell didTapAddFriendButton:(UIButton *)button;
- (void)friendCellDidTapAcceptRequestingFriendButton:(HWFriendCell *)cell;
- (void)friendCellDidTapDenyRequestingFriendButton:(HWFriendCell *)cell;

@end