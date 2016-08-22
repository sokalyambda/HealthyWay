//
//  HWAddFriendsViewController.m
//  HealthyWay
//
//  Created by Anastasia Mark on 17.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAddFriendsViewController.h"

#import "HWFriendsDataSource.h"

@interface HWAddFriendsViewController ()<UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) HWFriendsDataSource *friendsDataSource;

@end

@implementation HWAddFriendsViewController

#pragma mark - Accessors

- (HWFriendsDataSource *)friendsDataSource
{
    if (!_friendsDataSource) {
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.dimsBackgroundDuringPresentation = NO;
        _friendsDataSource = [[HWFriendsDataSource alloc] initWithSearchController:searchController
                                                                  resultsTableView:self.tableView];
    }
    return _friendsDataSource;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.friendsDataSource.searchController.searchBar;
}

#pragma mark - Actions

- (void)performAdditionalViewControllerAdjustments
{
    self.navigationItem.title = LOCALIZED(@"Add Friend");
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchControlle
{
    
}

@end
