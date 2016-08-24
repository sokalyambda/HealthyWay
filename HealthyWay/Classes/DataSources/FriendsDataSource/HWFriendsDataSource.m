//
//  HWFriendsDataSource.m
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFriendsDataSource.h"

#import "HWFriendCell.h"

#import "HWUserProfileData.h"

#import "HWBaseFriendCellConfigurationStrategy.h"

@interface HWFriendsDataSource ()<HWFriendCellDelegate>

@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSArray *requestingFriends;
@property (strong, nonatomic) NSArray *requestedFriends;
@property (strong, nonatomic) NSArray *requestedFriendsIds;

@end

@implementation HWFriendsDataSource

#pragma mark - Accessors

- (void)setRequestedFriends:(NSArray *)requestedFriends
{
    _requestedFriends = requestedFriends;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return HWFriendsStrategyTypeAcceptedFriends + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case HWFriendsStrategyTypeRequestedFriends:
            return self.requestedFriends.count;
        case HWFriendsStrategyTypeRequestingFriends:
            return self.requestingFriends.count;
        case HWFriendsStrategyTypeAcceptedFriends:
            return self.friends.count;
    }
    return 0;
}

- (UITableViewCell *)tableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    HWFriendCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWFriendCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    
    HWUserProfileData *userProfileData = nil;
    switch (indexPath.section) {
        case HWFriendsStrategyTypeRequestedFriends:
            userProfileData = self.requestedFriends[indexPath.row];
            [cell selectAddFriendButton:[self.requestedFriendsIds containsObject:userProfileData.userId]];
            break;
        case HWFriendsStrategyTypeRequestingFriends:
            userProfileData = self.requestingFriends[indexPath.row];
            break;
        case HWFriendsStrategyTypeAcceptedFriends:
            userProfileData = self.friends[indexPath.row];
            break;
    }
    if (!userProfileData) {
        return nil;
    }
    HWBaseFriendCellConfigurationStrategy *strategy = [HWBaseFriendCellConfigurationStrategy friendCellConfigurationStrategyWithType:(HWFriendsStrategyType)indexPath.section nameLabelText:userProfileData.fullName avatarURL:[NSURL URLWithString:userProfileData.avatarURLString] searchedText:nil];
    strategy.friendCell = cell;
    [cell configureWithConfigurationStrategy:strategy];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case HWFriendsStrategyTypeRequestedFriends:
            return !!self.requestedFriends.count ? LOCALIZED(@"Requested Friends") : nil;
        case HWFriendsStrategyTypeRequestingFriends:
            return !!self.requestingFriends.count ? LOCALIZED(@"Requesting Friends") : nil;
        case HWFriendsStrategyTypeAcceptedFriends:
            return !!self.friends.count ? LOCALIZED(@"Existed Friends") : nil;
    }
    return nil;
}

#pragma mark - Actions

- (void)fetchRequestedFriendsIdsWithCompletion:(void(^)())completion
{
    WEAK_SELF;
    [HWOperationsFacade fetchRequestedFriendsIdsOnSuccess:^(NSArray *requestedFriendsIds) {
        weakSelf.requestedFriendsIds = requestedFriendsIds;
        if (completion) {
            completion();
        }
    } onFailure:^(NSError *error) {
        if (completion) {
            completion();
        }
    }];
}

- (void)performNeededUpdatingActions
{
    dispatch_group_t friendsGroup = dispatch_group_create();
    
    WEAK_SELF;
    dispatch_group_enter(friendsGroup);
    [HWOperationsFacade fetchRequestedFriendsOnSuccess:^(NSArray *requestedFriends) {
        weakSelf.requestedFriends = requestedFriends;
        dispatch_group_leave(friendsGroup);
    } onFailure:^(NSError *error) {
        dispatch_group_leave(friendsGroup);
    }];
    
    dispatch_group_enter(friendsGroup);
    [HWOperationsFacade fetchRequestingFriendsOnSuccess:^(NSArray *requestingFriends) {
        weakSelf.requestingFriends = requestingFriends;
        dispatch_group_leave(friendsGroup);
    } onFailure:^(NSError *error) {
        dispatch_group_leave(friendsGroup);
    }];
    
    dispatch_group_enter(friendsGroup);
    [self fetchRequestedFriendsIdsWithCompletion:^{
        dispatch_group_leave(friendsGroup);
    }];
    
    dispatch_group_notify(friendsGroup, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)registerNibs
{
    UINib *friendCellNib = [UINib nibWithNibName:NSStringFromClass([HWFriendCell class]) bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:friendCellNib forCellReuseIdentifier:NSStringFromClass([HWFriendCell class])];
}

- (UIActivityIndicatorView *)activityIndicatorForRect:(CGRect)rect
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = rect;
    return activityIndicator;
}

#pragma mark - HWFriendCellDelegate

- (void)friendCell:(HWFriendCell *)cell didTapAddFriendButton:(UIButton *)button
{
    WEAK_SELF;
    [cell hideAddFriendButton:YES];
    UIActivityIndicatorView *activityIndicator = [self activityIndicatorForRect:button.frame];
    [cell.contentView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        HWUserProfileData *userToBeAFriend = self.requestedFriends[indexPath.row];
        if (!button.selected) {
            [HWOperationsFacade denyFriendsRequestToUserWithId:userToBeAFriend.userId onSuccess:^{
                [weakSelf performNeededUpdatingActions];
                [activityIndicator removeFromSuperview];
                [activityIndicator stopAnimating];
            } onFailure:^(NSError *error) {
                [cell hideAddFriendButton:NO];
                [activityIndicator removeFromSuperview];
                [activityIndicator stopAnimating];
            }];
        }
    }
}

- (void)friendCellDidTapAcceptRequestingFriendButton:(HWFriendCell *)cell
{
    
}

- (void)friendCellDidTapDenyRequestingFriendButton:(HWFriendCell *)cell
{
    
}

@end
