//
//  HWFriendCell.m
//  HealthyWay
//
//  Created by Anastasia Mark on 17.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFriendCell.h"
#import "HWCheckBoxButton.h"

#import "NSString+DecodeFromBase64.h"

@interface HWFriendCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet HWCheckBoxButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIView *requestingFriendButtonsContainer;

@end

@implementation HWFriendCell

#pragma mark - Actions

- (void)configureWithConfigurationStrategy:(id<HWFriendCellConfigurationStrategy>)strategy
{
    self.nameLabel.attributedText = strategy.attributedText;
    [self.avatarImageView sd_setImageWithURL:strategy.avatarURL];
    self.addFriendButton.hidden = strategy.hideAddFriendButton;
    self.requestingFriendButtonsContainer.hidden = !self.addFriendButton.isHidden;
}

- (void)selectAddFriendButton:(BOOL)select
{
    self.addFriendButton.selected = select;
}

- (void)hideAddFriendButton:(BOOL)hide
{
    self.addFriendButton.hidden = hide;
}

- (IBAction)addFriendClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(friendCell:didTapAddFriendButton:)]) {
        [self.delegate friendCell:self didTapAddFriendButton:sender];
    }
}

- (IBAction)applyFriendRequestClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(friendCellDidTapAcceptRequestingFriendButton:)]) {
        [self.delegate friendCellDidTapAcceptRequestingFriendButton:self];
    }
}

- (IBAction)denyFriendRequestClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(friendCellDidTapDenyRequestingFriendButton:)]) {
        [self.delegate friendCellDidTapDenyRequestingFriendButton:self];
    }
}

@end
