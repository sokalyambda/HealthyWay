//
//  HWBaseFriendCellConfigurationStrategy.m
//  HealthyWay
//
//  Created by Eugenity on 24.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseFriendCellConfigurationStrategy.h"

#import "HWExistedFriendConfigurationStrategy.h"
#import "HWRequestingFriendConfigurationStrategy.h"
#import "HWRequestedFriendConfigurationStrategy.h"

#import "HWFriendCell.h"

@interface HWBaseFriendCellConfigurationStrategy ()

@property (strong, nonatomic, readwrite) NSAttributedString *attributedText;
@property (strong, nonatomic) NSString *text;

@end

@implementation HWBaseFriendCellConfigurationStrategy

@synthesize text = _text;
@synthesize avatarURL = _avatarURL;
@synthesize searchedText = _searchedText;
@synthesize hideAddFriendButton = _hideAddFriendButton;

- (NSAttributedString *)attributedText
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
    if (self.searchedText) {
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[attrString.string rangeOfString:self.searchedText options:NSCaseInsensitiveSearch]];
    };
    return attrString;
}

- (void)setFriendCell:(HWFriendCell *)friendCell
{
    _friendCell = friendCell;
    [self p_configure];
}

#pragma mark - Lifecycle

- (instancetype)initWithNameLabelText:(NSString *)text
                            avatarURL:(NSURL *)avatarURL
                         searchedText:(NSString *)searchedText
{
    self = [super init];
    if (self) {
        _avatarURL = avatarURL;
        _searchedText = searchedText;
        _text = text;
    }
    return self;
}

+ (instancetype)friendCellConfigurationStrategyWithType:(HWFriendsStrategyType)type
                                          nameLabelText:(NSString *)text
                                              avatarURL:(NSURL *)avatarURL
                                           searchedText:(NSString *)searchedText
{
    switch (type) {
        case HWFriendsStrategyTypeAcceptedFriends:
            return [[HWExistedFriendConfigurationStrategy alloc] initWithNameLabelText:text avatarURL:avatarURL searchedText:searchedText];
        case HWFriendsStrategyTypeRequestedFriends:
            return [[HWRequestedFriendConfigurationStrategy alloc] initWithNameLabelText:text avatarURL:avatarURL searchedText:searchedText];
        case HWFriendsStrategyTypeRequestingFriends:
            return [[HWRequestingFriendConfigurationStrategy alloc] initWithNameLabelText:text avatarURL:avatarURL searchedText:searchedText];
    }
}

#pragma mark - Private

- (void)p_configure
{
    [(HWFriendCell *)self.friendCell configureWithConfigurationStrategy:self];
}

@end
