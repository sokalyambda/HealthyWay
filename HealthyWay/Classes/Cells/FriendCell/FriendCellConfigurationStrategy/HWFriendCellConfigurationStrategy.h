//
//  HWFriendCellConfigurationStrategy.h
//  HealthyWay
//
//  Created by Eugenity on 24.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HWFriendsStrategyType) {
    HWFriendsStrategyTypeRequestedFriends,
    HWFriendsStrategyTypeRequestingFriends,
    HWFriendsStrategyTypeAcceptedFriends
};

@protocol HWFriendCellConfigurationStrategy <NSObject>

@property (strong, nonatomic, readonly) NSAttributedString *attributedText;
@property (strong, nonatomic, readonly) NSURL *avatarURL;
@property (strong, nonatomic, readonly) NSString *searchedText;

@property (assign, nonatomic, readonly) BOOL hideAddFriendButton;

// (Apply/Decline buttons container) For existed friends we have to hide all action buttons
@property (assign, nonatomic, readonly) BOOL hideFriendRequestButtons;

+ (instancetype)friendCellConfigurationStrategyWithType:(HWFriendsStrategyType)type
                                          nameLabelText:(NSString *)text
                                              avatarURL:(NSURL *)avatarURL
                                           searchedText:(NSString *)searchedText;

@end
