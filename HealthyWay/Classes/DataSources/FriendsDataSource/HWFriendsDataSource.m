//
//  HWFriendsDataSource.m
//  HealthyWay
//
//  Created by Anastasia Mark on 17.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFriendsDataSource.h"

#import "HWFriendCell.h"

@interface HWFriendsDataSource ()

@property (nonatomic) NSArray *friends;

@end

@implementation HWFriendsDataSource

#pragma mark - Lifecycle

- (instancetype)initWithSearchController:(UISearchController *)searchController
{
    self = [super init];
    
    if (self) {
        _searchController = searchController;
        _searchController.searchResultsUpdater = self;
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
    [cell configureWithUser:user];
    
    return cell;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    DLog(@"text: %@", searchController.searchBar.text);
    [HWOperationsFacade fetchUsersWithFetchingType:HWFetchUsersTaskTypeTypeAll searchString:searchController.searchBar.text onSuccess:^(NSArray *users) {
        self.friends = users;
    } onFailure:^(NSError *error, BOOL isCancelled) {
        DLog(@"Error: %@", error.localizedDescription);
    }];
}

@end
