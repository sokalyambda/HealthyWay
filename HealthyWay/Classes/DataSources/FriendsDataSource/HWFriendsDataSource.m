//
//  HWFriendsDataSource.m
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HWFriendsDataSourceSection) {
    HWFriendsDataSourceSectionRequestedFriends,
    HWFriendsDataSourceSectionAcceptedFriends
};

#import "HWFriendsDataSource.h"

#import "HWFriendCell.h"

#import "HWUserProfileData.h"

@interface HWFriendsDataSource ()

@property (strong, nonatomic) NSArray *friends;
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
        case HWFriendsDataSourceSectionAcceptedFriends:
            userProfileData = self.friends[indexPath.row];
            break;
    }
    if (!userProfileData) {
        return nil;
    }
    
    HWFriendCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWFriendCell class]) forIndexPath:indexPath];
    [cell configureWithNameLabelText:userProfileData.fullName
                  base64AvatarString:userProfileData.avatarBase64];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case HWFriendsDataSourceSectionRequestedFriends:
            return LOCALIZED(@"Requested Friends");
        case HWFriendsDataSourceSectionAcceptedFriends:
            return LOCALIZED(@"Existed Friends");
    }
    return nil;
}

#pragma mark - Actions

- (void)performNeededUpdatingActions
{
    WEAK_SELF;
    [HWOperationsFacade fetchRequestedFriendsOnSuccess:^(NSArray *requestedFriends) {
        weakSelf.requestedFriends = requestedFriends;
    } onFailure:^(NSError *error) {
        
    }];
}

- (void)registerNibs
{
    UINib *friendCellNib = [UINib nibWithNibName:NSStringFromClass([HWFriendCell class]) bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:friendCellNib forCellReuseIdentifier:NSStringFromClass([HWFriendCell class])];
}

@end
