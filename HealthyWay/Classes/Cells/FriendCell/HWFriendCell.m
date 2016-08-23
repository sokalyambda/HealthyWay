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

@end

@implementation HWFriendCell

#pragma mark - Actions

- (void)configureWithNameLabelText:(NSString *)nameLabelText
                base64AvatarString:(NSString *)base64AvatarString
                   andSearchedText:(NSString *)searchedText;
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:nameLabelText];
    
    if (searchedText) {
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[attrString.string rangeOfString:searchedText options:NSCaseInsensitiveSearch]];
    }
    
    self.nameLabel.attributedText = attrString;
    self.avatarImageView.image = [base64AvatarString decodeBase64ToImage];
    
    self.addFriendButton.hidden = !searchedText;
}

- (void)configureWithNameLabelText:(NSString *)nameLabelText
                base64AvatarString:(NSString *)base64AvatarString
{
    [self configureWithNameLabelText:nameLabelText base64AvatarString:base64AvatarString andSearchedText:nil];
}

- (void)selectAddFriendButton:(BOOL)select
{
    self.addFriendButton.selected = select;
}

- (IBAction)addFriendClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(friendCell:didTapAddFriendButton:)]) {
        [self.delegate friendCell:self didTapAddFriendButton:sender];
    }
}

@end
