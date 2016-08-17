//
//  HWFriendCell.m
//  HealthyWay
//
//  Created by Anastasia Mark on 17.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFriendCell.h"

#import "HWUserProfileData.h"

#import "NSString+DecodeFromBase64.h"

@interface HWFriendCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation HWFriendCell

#pragma mark - Actions

- (void)configureWithUser:(HWUserProfileData *)user
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    self.avatarImageView.image = [user.avatarBase64 decodeBase64ToImage];
}

@end
