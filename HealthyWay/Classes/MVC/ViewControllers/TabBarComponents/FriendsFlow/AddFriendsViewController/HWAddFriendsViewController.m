//
//  HWAddFriendsViewController.m
//  HealthyWay
//
//  Created by Anastasia Mark on 17.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAddFriendsViewController.h"

#import "HWBaseDataSource.h"

@interface HWAddFriendsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) HWBaseDataSource *friendsDataSource;

@end

@implementation HWAddFriendsViewController

#pragma mark - Accessors

- (HWBaseDataSource *)friendsDataSource
{
    if (!_friendsDataSource) {
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.dimsBackgroundDuringPresentation = NO;
        _friendsDataSource = [HWBaseDataSource dataSourceWithType:HWDataSourceTypeAddFriends
                                                     forTableView:self.tableView
                                                 searchController:searchController];
    }
    return _friendsDataSource;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.friendsDataSource.searchController.searchBar;
}

#pragma mark - Actions

- (void)performAdditionalViewControllerAdjustments
{
    self.navigationItem.title = LOCALIZED(@"Add Friend");
}

@end
