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

@interface HWAddFriendsDataSource ()<HWFriendCellDelegate>

@property (nonatomic) NSArray *friends;
@property (nonatomic) UITableView *tableView;

@property (nonatomic) NSArray *requestedFriendsIds;

@end

@implementation HWAddFriendsDataSource

#pragma mark - Accessors

- (void)setFriends:(NSArray *)friends
{
    WEAK_SELF;
    [self fetchRequestedFriendsIdsWithCompletion:^{
        _friends = friends;
        
        [weakSelf.tableView reloadData];
    }];
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    
    [self adjustTableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

#pragma mark - Lifecycle

- (instancetype)initWithSearchController:(UISearchController *)searchController
                        resultsTableView:(UITableView *)tableView
{
    self = [super init];
    
    if (self) {
        _searchController = searchController;
        _searchController.searchResultsUpdater = self;
        
        self.tableView = tableView;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWFriendCell class]) forIndexPath:indexPath];
    HWUserProfileData *user = self.friends[indexPath.row];
    [cell configureWithNameLabelText:user.fullName
                  base64AvatarString:user.avatarBase64
                     andSearchedText:self.searchController.searchBar.text];
    [cell selectAddFriendButton:[self.requestedFriendsIds containsObject:user.userId]];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    WEAK_SELF;
    [HWOperationsFacade fetchUsersWithFetchingType:HWFetchUsersTaskTypeTypeAll searchString:searchController.searchBar.text onSuccess:^(NSArray *users) {
        weakSelf.friends = users;
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

- (void)adjustTableView
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self registerNibs];
}

#pragma mark - HWFriendCellDelegate

- (void)friendCell:(HWFriendCell *)cell didTapAddFriendButton:(UIButton *)button
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        HWUserProfileData *userToBeAFriend = self.friends[indexPath.row];
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
