//
//  HWFriendCell.h
//  HealthyWay
//
//  Created by Anastasia Mark on 17.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@protocol HWFriendCellDelegate;

@interface HWFriendCell : UITableViewCell

@property (weak, nonatomic) id<HWFriendCellDelegate> delegate;

- (void)selectAddFriendButton:(BOOL)select;
- (void)configureWithNameLabelText:(NSString *)nameLabelText
                base64AvatarString:(NSString *)base64AvatarString
                   andSearchedText:(NSString *)searchedText;
- (void)configureWithNameLabelText:(NSString *)nameLabelText
                base64AvatarString:(NSString *)base64AvatarString;

@end

@protocol HWFriendCellDelegate <NSObject>

@optional
- (void)friendCell:(HWFriendCell *)cell didTapAddFriendButton:(UIButton *)button;

@end