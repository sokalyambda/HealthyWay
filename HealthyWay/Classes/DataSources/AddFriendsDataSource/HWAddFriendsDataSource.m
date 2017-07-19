//
//  HWFriendsDataSource.m
//  HealthyWay
//
//  Created by Anastasia Mark on 17.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAddFriendsDataSource.h"

#import "HWFriendCell.h"

#import "HWUserProfileData.h"

#import "HWBaseFriendCellConfigurationStrategy.h"

@interface HWAddFriendsDataSource ()<HWFriendCellDelegate>

@property (nonatomic) NSArray *possibleFriends;

@property (nonatomic) NSArray *requestedFriendsIds;

@end

@implementation HWAddFriendsDataSource

#pragma mark - Accessors

- (NSArray *)dataSourceArray
{
    return self.possibleFriends;
}

- (void)setPossibleFriends:(NSArray *)friends
{
    WEAK_SELF;
    [self fetchRequestedFriendsIdsWithCompletion:^{
        _possibleFriends = friends;
        
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    HWFriendCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWFriendCell class]) forIndexPath:indexPath];
    HWUserProfileData *user = self.possibleFriends[indexPath.row];
    HWBaseFriendCellConfigurationStrategy *strategy = [HWBaseFriendCellConfigurationStrategy friendCellConfigurationStrategyWithType:HWFriendsStrategyTypeRequestedFriends
                                                                                                                       nameLabelText:user.fullName
                                                                                                                           avatarURL:[NSURL URLWithString:user.avatarURLString]
                                                                                                                        searchedText:self.searchController.searchBar.text];
    strategy.friendCell = cell;
    [cell configureWithConfigurationStrategy:strategy];
    
    [cell selectAddFriendButton:[self.requestedFriendsIds containsObject:user.userId]];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    WEAK_SELF;
    [HWOperationsFacade fetchUsersWithFetchingType:HWFetchUsersTaskTypeTypeAllExceptExistedFriends searchString:searchController.searchBar.text onSuccess:^(NSArray *users) {
        weakSelf.possibleFriends = users;
    } onFailure:^(NSError *error, BOOL isCancelled) {
        
    }];
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

- (void)registerNibs
{
    UINib *friendCellNib = [UINib nibWithNibName:NSStringFromClass([HWFriendCell class]) bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:friendCellNib forCellReuseIdentifier:NSStringFromClass([HWFriendCell class])];
}

#pragma mark - HWFriendCellDelegate

- (void)friendCell:(HWFriendCell *)cell didTapAddFriendButton:(UIButton *)button
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        HWUserProfileData *userToBeAFriend = self.possibleFriends[indexPath.row];
        if (button.selected) {
            [HWOperationsFacade sendFriendsRequestToUserWithId:userToBeAFriend.userId onSuccess:^{
                
            } onFailure:^(NSError *error) {
                
            }];
        } else {
            [HWOperationsFacade denyFriendsRequestToUserWithId:userToBeAFriend.userId onSuccess:^{
                
            } onFailure:^(NSError *error) {
                
            }];
        }
    }
}

@end
