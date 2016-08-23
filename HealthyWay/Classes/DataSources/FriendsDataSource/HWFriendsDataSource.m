//
//  HWFriendsDataSource.m
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HWFriendsDataSourceSection) {
    HWFriendsDataSourceSectionRequestedFriends,
    HWFriendsDataSourceSectionRequestingFriends,
    HWFriendsDataSourceSectionAcceptedFriends
};

#import "HWFriendsDataSource.h"

#import "HWFriendCell.h"

#import "HWUserProfileData.h"

@interface HWFriendsDataSource ()

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
    return HWFriendsDataSourceSectionAcceptedFriends + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case HWFriendsDataSourceSectionRequestedFriends:
            return self.requestedFriends.count;
        case HWFriendsDataSourceSectionRequestingFriends:
            return self.requestingFriends.count;
        case HWFriendsDataSourceSectionAcceptedFriends:
            return self.friends.count;
    }
    return 0;
}

- (UITableViewCell *)tableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    HWUserProfileData *userProfileData = nil;
    switch (indexPath.section) {
        case HWFriendsDataSourceSectionRequestedFriends:
            userProfileData = self.requestedFriends[indexPath.row];
            break;
        case HWFriendsDataSourceSectionRequestingFriends:
            userProfileData = self.requestingFriends[indexPath.row];
            break;
        case HWFriendsDataSourceSectionAcceptedFriends:
            userProfileData = self.friends[indexPath.row];
            break;
    }
    if (!userProfileData) {
        return nil;
    }
    
    HWFriendCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWFriendCell class]) forIndexPath:indexPath];
    [cell configureWithNameLabelText:userProfileData.fullName
                           avatarURL:[NSURL URLWithString:userProfileData.avatarURLString]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case HWFriendsDataSourceSectionRequestedFriends:
            return LOCALIZED(@"Requested Friends");
        case HWFriendsDataSourceSectionRequestingFriends:
            return LOCALIZED(@"Requesting Friends");
        case HWFriendsDataSourceSectionAcceptedFriends:
            return LOCALIZED(@"Existed Friends");
    }
    return nil;
}

#pragma mark - Actions

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
    
    dispatch_group_notify(friendsGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
    });
}

- (void)registerNibs
{
    UINib *friendCellNib = [UINib nibWithNibName:NSStringFromClass([HWFriendCell class]) bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:friendCellNib forCellReuseIdentifier:NSStringFromClass([HWFriendCell class])];
}

@end
